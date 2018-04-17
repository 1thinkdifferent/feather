//
//  Theme.swift
//  Regxr
//
//  Created by Luka Kerr on 17/4/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

struct Theme {
  var id: Int = -1
  var name: String = "Common"
  var appearance: NSAppearance.Name = NSAppearance.Name.vibrantDark
  var text: NSColor = NSColor.black
  var purple: NSColor = NSColor(red: 0.60, green: 0.26, blue: 0.77, alpha: 1)
  var blue: NSColor = NSColor(red: 0.25, green: 0.51, blue: 0.77, alpha: 1)
  
  init(id: Int, name: String, appearance: NSAppearance.Name, text: NSColor) {
    self.id = id
    self.name = name
    self.appearance = appearance
    self.text = text
  }
  
}

let lightTheme = Theme(id: 0,
                       name: "Light",
                       appearance: NSAppearance.Name.vibrantLight,
                       text: NSColor.black)

let darkTheme = Theme(id: 1,
                      name: "Dark",
                      appearance: NSAppearance.Name.vibrantDark,
                      text: NSColor.white)

let commonTheme = darkTheme
