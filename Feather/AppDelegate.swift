//
//  AppDelegate.swift
//  Regxr
//
//  Created by Luka Kerr on 23/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

let defaults = UserDefaults.standard

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Main window
    let window = NSApplication.shared.windows.first
    
    // Window properties
    window?.appearance = NSAppearance(named: currentTheme.appearance)
    window?.titleVisibility = NSWindow.TitleVisibility.hidden;
    window?.titlebarAppearsTransparent = true;
    window?.styleMask.insert(.fullSizeContentView)
    window?.isOpaque = false
    window?.invalidateShadow()
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    let window = sender.windows.first
    if flag {
      window?.orderFront(sender)
    } else {
      window?.makeKeyAndOrderFront(sender)
    }
    return true
  }
  
}
