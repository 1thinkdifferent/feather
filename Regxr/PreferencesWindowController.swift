//
//  PreferencesWindowController.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

  override func windowDidLoad() {
    super.windowDidLoad()
    
    if let window = window {
      let appearance = currentTheme.appearance
      window.appearance = NSAppearance(named: appearance)
      window.titleVisibility = NSWindow.TitleVisibility.hidden
      window.titlebarAppearsTransparent = true
      window.styleMask.insert(.fullSizeContentView)
      window.isOpaque = false
      window.invalidateShadow()
      window.center()
      window.makeKeyAndOrderFront(nil)
    }
    
    NSApp.activate(ignoringOtherApps: true)
  }
  
}
