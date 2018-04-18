//
//  Theme.swift
//  Regxr
//
//  Created by Luka Kerr on 17/4/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

struct Theme {
  var id: Int = 0
  var name: String = "Light"
  var appearance: NSAppearance.Name = NSAppearance.Name.vibrantLight
  var text: NSColor = NSColor.black
  var purple: NSColor = NSColor(red: 0.60, green: 0.26, blue: 0.77, alpha: 1)
  var blue: NSColor = NSColor(red: 0.25, green: 0.51, blue: 0.77, alpha: 1)
  
  func getTheme(_ n: Notification? = nil) -> String {
    var theme = n?.object as? String ?? defaults.string(forKey: "theme")
    if theme == nil {
      theme = DEFAULT_THEME
    }
    if let theme = theme {
      return theme
    }
    return self.name
  }
  
  mutating func setTheme(_ theme: String) {
    if (theme == "Light") {
      self.id = 0
      self.name = theme
      self.appearance = NSAppearance.Name.vibrantLight
      self.text = NSColor.black
    } else {
      self.id = 1
      self.name = "Dark"
      self.appearance = NSAppearance.Name.vibrantDark
      self.text = NSColor.white
    }
    defaults.setValue(theme, forKey: "theme")
  }
}

var currentTheme = Theme()
