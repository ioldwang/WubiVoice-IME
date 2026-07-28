#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <rime_api.h>

struct Case {
  std::string schema;
  std::string input;
  std::string expected;
  std::string mode = "first";
};

size_t codepoint_count(const char* text) {
  size_t count = 0;
  for (const unsigned char* cursor =
           reinterpret_cast<const unsigned char*>(text);
       *cursor;
       ++cursor) {
    if ((*cursor & 0xc0) != 0x80) {
      ++count;
    }
  }
  return count;
}

int main(int argc, char** argv) {
  if (argc != 4) {
    std::cerr << "usage: rime_snapshot SHARED USER FIXTURE\n";
    return 2;
  }

  const std::string shared = argv[1];
  const std::string user = argv[2];
  std::ifstream fixture(argv[3]);
  std::vector<Case> cases;
  for (std::string line; std::getline(fixture, line);) {
    std::istringstream stream(line);
    Case item;
    std::getline(stream, item.schema, '\t');
    std::getline(stream, item.input, '\t');
    std::getline(stream, item.expected, '\t');
    std::getline(stream, item.mode, '\t');
    if (item.mode.empty()) {
      item.mode = "first";
    }
    if (!item.schema.empty()) {
      cases.push_back(item);
    }
  }

  RimeApi* api = rime_get_api();
  RIME_STRUCT(RimeTraits, traits);
  traits.shared_data_dir = shared.c_str();
  traits.user_data_dir = user.c_str();
  traits.log_dir = user.c_str();
  traits.app_name = "rime.ai.hojo.WubiVoice.tests";
  api->setup(&traits);
  api->initialize(nullptr);
  if (api->start_maintenance(True)) {
    api->join_maintenance_thread();
  }

  bool passed = true;
  for (const auto& item : cases) {
    RimeSessionId session = api->create_session();
    bool case_passed = session
        && api->select_schema(session, item.schema.c_str());
    if (case_passed && item.mode == "all_single") {
      api->set_option(session, "single_char", True);
    }
    case_passed = case_passed
        && api->simulate_key_sequence(session, item.input.c_str());
    RIME_STRUCT(RimeCommit, commit);
    const bool got_commit = case_passed
        && api->get_commit(session, &commit);
    RIME_STRUCT(RimeContext, context);
    const bool got_context = case_passed
        && api->get_context(session, &context);
    const std::string actual = got_commit
        ? commit.text
        : got_context && context.menu.num_candidates > 0
            ? context.menu.candidates[0].text
            : "";
    bool result = false;
    if (item.mode == "has_candidates") {
      result = got_context && context.menu.num_candidates > 0;
    } else if (item.mode == "all_single") {
      result = got_context && context.menu.num_candidates > 0;
      for (int index = 0;
           result && index < context.menu.num_candidates;
           ++index) {
        result = codepoint_count(context.menu.candidates[index].text) == 1;
      }
    } else if (item.mode == "commit") {
      result = got_commit && actual == item.expected;
    } else {
      result = actual == item.expected;
    }
    if (!result) {
      std::cerr << item.schema << '\t' << item.input
                << " expected " << item.expected
                << " mode " << item.mode
                << " got " << actual << '\n';
      passed = false;
    }
    if (got_context) {
      api->free_context(&context);
    }
    if (got_commit) {
      api->free_commit(&commit);
    }
    if (session) {
      api->destroy_session(session);
    }
  }

  api->finalize();
  return passed ? 0 : 1;
}
