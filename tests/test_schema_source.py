from pathlib import Path

root = Path("data/wubivoice")
schema = (root / "wubi86_jidian.schema.yaml").read_text()
defaults = (root / "wubivoice.default.custom.yaml").read_text()
dictionary = (root / "wubi86_jidian.dict.yaml").read_text().splitlines()

assert 'name: "WubiVoice 极点五笔 86"' in schema
assert "max_code_length: 4" in schema
assert "auto_select: true" in schema
assert "enable_user_dict: true" in schema
assert "name: single_char" in schema
assert "lua_filter@*wubivoice_single_char_filter" in schema
assert "accept: minus, send: Page_Up" in defaults
assert "accept: equal, send: Page_Down" in defaults
assert "Shift_L: commit_code" in defaults
assert "Shift_R: noop" in defaults
assert "- schema: wubi86_jidian" in defaults

expected = dict(zip(
    "abcdefghijklmnopqrstuvwxy",
    "工了以在有地一上不是中国同民为这我的要和产发人经主",
))
first = {}
for line in dictionary:
    fields = line.split("\t")
    if len(fields) >= 2 and fields[1] in expected:
        first.setdefault(fields[1], fields[0])

assert first == expected
