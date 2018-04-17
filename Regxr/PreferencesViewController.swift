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
    
    let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
    let showReferenceOnStartup = defaults.bool(forKey: "showReference")
    themeButton.selectedSegment = (theme == "Light") ? lightTheme.id : darkTheme.id
    referencesManualCheckbox.state = showReferenceOnStartup ? .on : .off
  }
  
  @IBAction func themeChanged(_ sender: NSSegmentedControl) {
    let theme = defaults.string(forKey: "theme") ?? DEFAULT_THEME
    var chosenTheme = theme
    
    if (sender.selectedSegment == 0) {
      // Light theme chosen
      chosenTheme = "Light"
      self.view.window?.appearance = NSAppearance(named: lightTheme.appearance)
    } else {
      chosenTheme = "Dark"
      self.view.window?.appearance = NSAppearance(named: darkTheme.appearance)
    }
    wc.setWindowColor(theme: chosenTheme)
    
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
