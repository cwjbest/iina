//
//  KeyCodeHelper.swift
//  iina
//
//  Created by lhc on 12/12/2016.
//  Copyright © 2016 lhc. All rights reserved.
//

import Foundation
import Carbon

class KeyCodeHelper {

  static let keyMap: [UInt16 : (String, String?)] = [
    0x00: ("a", "A"),
    0x01: ("s", "S"),
    0x02: ("d", "D"),
    0x03: ("f", "F"),
    0x04: ("h", "H"),
    0x05: ("g", "G"),
    0x06: ("z", "Z"),
    0x07: ("x", "X"),
    0x08: ("c", "C"),
    0x09: ("v", "V"),
    0x0B: ("b", "B"),
    0x0C: ("q", "Q"),
    0x0D: ("w", "W"),
    0x0E: ("e", "E"),
    0x0F: ("r", "R"),
    0x10: ("y", "Y"),
    0x11: ("t", "T"),
    0x12: ("1", "!"),
    0x13: ("2", "@"),
    0x14: ("3", "SHARP"),
    0x15: ("4", "$"),
    0x16: ("6", "^"),
    0x17: ("5", "%"),
    0x18: ("=", "+"),
    0x19: ("9", "("),
    0x1A: ("7", "&"),
    0x1B: ("-", "_"),
    0x1C: ("8", "*"),
    0x1D: ("0", ")"),
    0x1E: ("]", "}"),
    0x1F: ("o", "O"),
    0x20: ("u", "U"),
    0x21: ("[", "{"),
    0x22: ("i", "I"),
    0x23: ("p", "P"),
    0x25: ("l", "L"),
    0x26: ("j", "J"),
    0x27: ("'", "\"\"\""),
    0x28: ("k", "K"),
    0x29: (";", ":"),
    0x2A: ("\"\\\"", "|"),
    0x2B: (",", "<"),
    0x2C: ("/", "?"),
    0x2D: ("n", "N"),
    0x2E: ("m", "M"),
    0x2F: (".", ">"),
    0x32: ("`", "~"),
    0x41: ("KP_DEC", nil),
    0x43: ("*", nil),
    0x45: ("+", nil),
    // 0x47: ("KeypadClear", nil),
    0x4B: ("/", nil),
    0x4C: ("KP_ENTER", nil),
    0x4E: ("-", nil),
    0x51: ("=", nil),
    0x52: ("KP0", nil),
    0x53: ("KP1", nil),
    0x54: ("KP2", nil),
    0x55: ("KP3", nil),
    0x56: ("KP4", nil),
    0x57: ("KP5", nil),
    0x58: ("KP6", nil),
    0x59: ("KP7", nil),
    0x5B: ("KP8", nil),
    0x5C: ("KP9", nil),
    
    0x24: ("ENTER", nil),
    0x30: ("TAB", nil),
    0x31: ("SPACE", nil),
    0x33: ("BS", nil),
    0x35: ("ESC", nil),
    // 0x37: ("Command", nil),
    // 0x38: ("Shift", nil),
    // 0x39: ("CapsLock", nil),
    // 0x3A: ("Option", nil),
    // 0x3B: ("Control", nil),
    // 0x3C: ("RightShift", nil),
    // 0x3D: ("RightOption", nil),
    // 0x3E: ("RightControl", nil),
    // 0x3F: ("Function", nil),
    0x40: ("F17", nil),
    // 0x48: ("VolumeUp", nil),
    // 0x49: ("VolumeDown", nil),
    // 0x4A: ("Mute", nil),
    0x4F: ("F18", nil),
    0x50: ("F19", nil),
    0x5A: ("F20", nil),
    0x60: ("F5", nil),
    0x61: ("F6", nil),
    0x62: ("F7", nil),
    0x63: ("F3", nil),
    0x64: ("F8", nil),
    0x65: ("F9", nil),
    0x67: ("F11", nil),
    0x69: ("F13", nil),
    0x6A: ("F16", nil),
    0x6B: ("F14", nil),
    0x6D: ("F10", nil),
    0x6F: ("F12", nil),
    0x71: ("F15", nil),
    0x72: ("INS", nil),
    0x73: ("HOME", nil),
    0x74: ("PGUP", nil),
    0x75: ("DEL", nil),
    0x76: ("F4", nil),
    0x77: ("END", nil),
    0x78: ("F2", nil),
    0x79: ("PGDWN", nil),
    0x7A: ("F1", nil),
    0x7B: ("LEFT", nil),
    0x7C: ("RIGHT", nil),
    0x7D: ("DOWN", nil),
    0x7E: ("UP", nil),
    0x7F: ("POWER", nil) // This should be KeyCode::PC_POWER.
  ]

  static var reversedKeyMapForShift: [String: String] = keyMap.reduce([:]) { partial, keyMap in
    var partial = partial
    if let value = keyMap.value.1 {
      partial[value] = keyMap.value.0
    }
    return partial
  }

  static func canBeModifiedByShift(_ key: UInt16) -> Bool {
    return key != 0x24 && (key <= 0x2F || key == 0x32)
  }

  static func isPrintable(_ char: String) -> Bool {
    let utf8View = char.utf8
    return utf8View.count == 1 && utf8View.first! > 32 && utf8View.first! < 127
  }

  static func mpvKeyCode(from event: NSEvent) -> String {
    var keyString = ""
    let keyChar: String
    let keyCode = event.keyCode
    let modifiers = event.modifierFlags

    // shift

    if let char = event.charactersIgnoringModifiers, isPrintable(char) {
      keyChar = char
    } else {
      // find the key from key code
      guard let keyName = KeyCodeHelper.keyMap[keyCode] else {
        Utility.log("Undefined key code?")
        return ""
      }
      if modifiers.contains(.shift) {
        if KeyCodeHelper.canBeModifiedByShift(keyCode) {
          keyChar = keyName.1!
        } else {
          keyChar = keyName.0
          keyString += "Shift+"
        }
      } else {
        keyChar = keyName.0
      }
    }
    // control
    if modifiers.contains(.control) {
      keyString += "Ctrl+"
    }
    // alt
    if modifiers.contains(.option) {
      keyString += "Alt+"
    }
    // meta
    if modifiers.contains(.command) {
      keyString += "Meta+"
    }
    // char
    keyString += keyChar
    return keyString
  }

}


fileprivate let NSEventKeyCodeMapping: [Int: String] = [
  kVK_F1: "F1",
  kVK_F2: "F2",
  kVK_F3: "F3",
  kVK_F4: "F4",
  kVK_F5: "F5",
  kVK_F6: "F6",
  kVK_F7: "F7",
  kVK_F8: "F8",
  kVK_F9: "F9",
  kVK_F10: "F10",
  kVK_F11: "F11",
  kVK_F12: "F12",
  kVK_F13: "F13",
  kVK_F14: "F14",
  kVK_F15: "F15",
  kVK_F16: "F16",
  kVK_F17: "F17",
  kVK_F18: "F18",
  kVK_F19: "F19",
  kVK_Space: "␣",
  kVK_Escape: "⎋",
  kVK_Delete: "⌦",
  kVK_ForwardDelete: "⌫",
  kVK_LeftArrow: "←",
  kVK_RightArrow: "→",
  kVK_UpArrow: "↑",
  kVK_DownArrow: "↓",
  kVK_Help: "",
  kVK_PageUp: "⇞",
  kVK_PageDown: "⇟",
  kVK_Tab: "⇥",
  kVK_Return: "⏎",
  kVK_ANSI_Keypad0: "0",
  kVK_ANSI_Keypad1: "1",
  kVK_ANSI_Keypad2: "2",
  kVK_ANSI_Keypad3: "3",
  kVK_ANSI_Keypad4: "4",
  kVK_ANSI_Keypad5: "5",
  kVK_ANSI_Keypad6: "6",
  kVK_ANSI_Keypad7: "7",
  kVK_ANSI_Keypad8: "8",
  kVK_ANSI_Keypad9: "9",
  kVK_ANSI_KeypadDecimal: ".",
  kVK_ANSI_KeypadMultiply: "*",
  kVK_ANSI_KeypadPlus: "+",
  kVK_ANSI_KeypadClear: "Clear",
  kVK_ANSI_KeypadDivide: "/",
  kVK_ANSI_KeypadEnter: "↩︎",
  kVK_ANSI_KeypadMinus: "-",
  kVK_ANSI_KeypadEquals: "="
]

extension NSEvent {
  var readableKeyDescription: (String, String) {
    get {

      let rawKeyCharacter: String
      if let char = NSEventKeyCodeMapping[Int(self.keyCode)] {
        rawKeyCharacter = char
      } else {
        let inputSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue()
        if let layoutData = TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData) {
          let dataRef = unsafeBitCast(layoutData, to: CFData.self)
          let keyLayout = unsafeBitCast(CFDataGetBytePtr(dataRef), to: UnsafePointer<UCKeyboardLayout>.self)
          var deadKeyState = UInt32(0)
          let maxLength = 4
          var actualLength = 0
          var actualString = [UniChar](repeating: 0, count: maxLength)
          let error = UCKeyTranslate(keyLayout,
                                     UInt16(self.keyCode),
                                     UInt16(kUCKeyActionDisplay),
                                     UInt32((0 >> 8) & 0xFF),
                                     UInt32(LMGetKbdType()),
                                     OptionBits(kUCKeyTranslateNoDeadKeysBit),
                                     &deadKeyState,
                                     maxLength,
                                     &actualLength,
                                     &actualString)
          if error == 0 {
            rawKeyCharacter = String(utf16CodeUnits: &actualString, count: maxLength).uppercased()

          } else {
            rawKeyCharacter = KeyCodeHelper.keyMap[self.keyCode]?.0 ?? ""
          }
        } else {
          rawKeyCharacter = KeyCodeHelper.keyMap[self.keyCode]?.0 ?? ""
        }
      }

      return (([(.control, "⌃"), (.option, "⌥"), (.shift, "⇧"), (.command, "⌘")] as [(NSEvent.ModifierFlags, String)])
        .map { self.modifierFlags.contains($0.0) ? $0.1 : "" }
        .joined()
        .appending(rawKeyCharacter), rawKeyCharacter)
    }
  }
}
