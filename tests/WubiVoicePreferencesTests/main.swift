import Foundation

let suite = "WubiVoicePreferencesTests-\(UUID().uuidString)"
let defaults = UserDefaults(suiteName: suite)!
defer { defaults.removePersistentDomain(forName: suite) }

let preferences = WubiVoicePreferences(defaults: defaults)
precondition(!preferences.enterClearsComposition)
precondition(!preferences.shouldClearEnter(
  isReturn: true,
  isComposing: true
))

preferences.enterClearsComposition = true
precondition(preferences.shouldClearEnter(
  isReturn: true,
  isComposing: true
))
precondition(!preferences.shouldClearEnter(
  isReturn: false,
  isComposing: true
))
precondition(!preferences.shouldClearEnter(
  isReturn: true,
  isComposing: false
))
