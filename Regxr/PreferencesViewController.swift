//
//  PreferencesViewController.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
  
  @IBOutlet weak var themeButton: NSSegmentedControl!
  @IBOutlet weak var referencesManualCheckbox: NSButton!

  var wc = WindowController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let showReferenceOnStartup = defaults.bool(forKey: "showReference")
    themeButton.selectedSegment = currentTheme.id
    referencesManualCheckbox.state = showReferenceOnStartup ? .on : .off
  }
  
  @IBAction func themeChanged(_ sender: NSSegmentedControl) {
    let chosenTheme = (sender.selectedSegment == 0) ? "Light" : "Dark"
    currentTheme.setTheme(chosenTheme)
    self.view.window?.appearance = NSAppearance(named: currentTheme.appearance)
    wc.setWindowColor()
    
    NotificationCenter.default.post(
      name: NSNotification.Name(rawValue: "changeThemeNotification"),
      object: chosenTheme
    )
    
    defaults.setValue(chosenTheme, forKey: "theme")
  }
  
  @IBAction func referenceManualChecked(_ sender: NSButton) {
    defaults.setValue((sender.state.rawValue != 0), forKey: "showReference")
  }
}
