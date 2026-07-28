import Foundation

struct WubiVoicePreferences {
  private static let enterClearKey = "enterClearsComposition"
  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  var enterClearsComposition: Bool {
    get { defaults.bool(forKey: Self.enterClearKey) }
    nonmutating set { defaults.set(newValue, forKey: Self.enterClearKey) }
  }

  func shouldClearEnter(isReturn: Bool, isComposing: Bool) -> Bool {
    enterClearsComposition && isReturn && isComposing
  }
}
