#!/bin/bash
set -euo pipefail

plist=resources/Info.plist

test "$(plutil -extract TISInputSourceID raw "$plist")" = "ai.hojo.WubiVoice"
test "$(plutil -extract CFBundleExecutable raw "$plist")" = "WubiVoice"
test "$(plutil -extract CFBundleName raw "$plist")" = "WubiVoice"
test "$(plutil -extract InputMethodConnectionName raw "$plist")" = "WubiVoice_Connection"
test "$(plutil -extract InputMethodServerControllerClass raw "$plist")" = "WubiVoice.SquirrelInputController"
test "$(/usr/libexec/PlistBuddy -c 'Print :ComponentInputModeDict:tsInputModeListKey:ai.hojo.WubiVoice.Hans:TISInputSourceID' "$plist")" = "ai.hojo.WubiVoice.Hans"
test "$(/usr/libexec/PlistBuddy -c 'Print :ComponentInputModeDict:tsInputModeListKey:ai.hojo.WubiVoice.Hant:TISInputSourceID' "$plist")" = "ai.hojo.WubiVoice.Hant"

rg -q 'PRODUCT_BUNDLE_IDENTIFIER = ai\.hojo\.WubiVoice;' Squirrel.xcodeproj/project.pbxproj
rg -q 'PRODUCT_NAME = WubiVoice;' Squirrel.xcodeproj/project.pbxproj
rg -q '/Library/Input Methods/WubiVoice\.app' sources/Main.swift Makefile
rg -q 'case hans = "ai\.hojo\.WubiVoice\.Hans"' sources/InputSource.swift
rg -Fq 'setCString("WubiVoice", to: \.distribution_name)' sources/SquirrelApplicationDelegate.swift

! rg -n 'rime\.github\.io/release/squirrel|Squirrel\.pkg|/Squirrel\.app' \
  resources package scripts Makefile
