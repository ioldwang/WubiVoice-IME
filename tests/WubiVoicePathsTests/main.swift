import Foundation

let root = FileManager.default.temporaryDirectory
  .appendingPathComponent("WubiVoicePaths-\(UUID().uuidString)")
let bundled = root.appendingPathComponent("wubivoice.default.custom.yaml")
let user = WubiVoicePaths.userDirectory(home: root)
try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
try Data("patch:\n  schema_list: []\n".utf8).write(to: bundled)
defer { try? FileManager.default.removeItem(at: root) }

precondition(user.path.hasSuffix("/Library/WubiVoice/Rime"))
precondition(!user.path.hasSuffix("/Library/Rime"))

try WubiVoicePaths.seedDefaultConfiguration(from: bundled, to: user)
let installed = user.appendingPathComponent("default.custom.yaml")
precondition(FileManager.default.fileExists(atPath: installed.path))

try Data("user-owned".utf8).write(to: installed)
try WubiVoicePaths.seedDefaultConfiguration(from: bundled, to: user)
let preserved = try String(contentsOf: installed, encoding: .utf8)
precondition(preserved == "user-owned")
