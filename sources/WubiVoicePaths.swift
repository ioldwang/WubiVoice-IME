import Foundation

enum WubiVoicePaths {
  static func userDirectory(home: URL) -> URL {
    home.appending(components: "Library", "WubiVoice", "Rime")
  }

  static func seedDefaultConfiguration(from bundled: URL, to userDirectory: URL) throws {
    try FileManager.default.createDirectory(
      at: userDirectory,
      withIntermediateDirectories: true
    )
    let destination = userDirectory.appendingPathComponent("default.custom.yaml")
    guard !FileManager.default.fileExists(atPath: destination.path) else { return }
    try FileManager.default.copyItem(at: bundled, to: destination)
  }
}
