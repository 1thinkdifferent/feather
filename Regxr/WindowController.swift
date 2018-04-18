//
//  WindowController.swift
//  Regxr
//
//  Created by Luka Kerr on 24/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Set saved theme
    if let theme = defaults.string(forKey: "theme") {
      currentTheme.setTheme(theme)
    }
    
    if let window = window {
      setWindowColor()
      window.titleVisibility = NSWindow.TitleVisibility.hidden;
      window.titlebarAppearsTransparent = true;
      window.styleMask.insert(.fullSizeContentView)
      window.isOpaque = false
      window.invalidateShadow()
    }
  }
  
  func setWindowColor() {
    window?.appearance = NSAppearance(named: currentTheme.appearance)
  }
  
}
