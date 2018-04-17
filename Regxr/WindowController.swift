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
    
    let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
    
    if let window = window {
      setWindowColor(theme: theme)
      window.titleVisibility = NSWindow.TitleVisibility.hidden;
      window.titlebarAppearsTransparent = true;
      window.styleMask.insert(.fullSizeContentView)
      window.isOpaque = false
      window.invalidateShadow()
    }
    
  }
  
  func setWindowColor(theme: String) {
    let appearance = (theme == "Light") ? lightTheme.appearance : darkTheme.appearance;
    window?.appearance = NSAppearance(named: appearance)
  }
  
}
