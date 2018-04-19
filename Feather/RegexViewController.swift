//
//  ViewController.swift
//  Regxr
//
//  Created by Luka Kerr on 23/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

let DEFAULT_THEME = "Light"
let DEFAULT_SHOW_REFERENCE = true

class RegexViewController: NSViewController, NSWindowDelegate {
  
  @IBOutlet var regexInput: NSTextView!
  @IBOutlet var textOutput: NSTextView!
  @IBOutlet weak var invalidLabel: NSTextField!
  @IBOutlet weak var topHalf: NSVisualEffectView!
  @IBOutlet weak var bottomHalf: NSVisualEffectView!
  @IBOutlet weak var referenceButton: NSButton!

  let highlighter = RegexHighlighter()
  
  @objc dynamic var regexTextInput: String = "" {
    didSet {
      parse()
    }
  }
  
  @objc private var attributedRegexTextInput: NSAttributedString {
    get {
      return NSAttributedString(string: self.regexTextInput)
    }
    set {
      self.regexTextInput = newValue.string
      parse()
    }
  }
  
  @objc dynamic var textInput: String = "" {
    didSet {
      parse()
    }
  }
  
  @objc private var attributedTextInput: NSAttributedString {
    get {
      return NSAttributedString(string: self.textInput)
    }
    set {
      self.textInput = newValue.string
    }
  }
  
  // Needed because NSTextView only has an "Attributed String" binding
  @objc private static let keyPathsForValuesAffectingAttributedTextInput: Set<String> = [
    #keyPath(textInput),
    #keyPath(regexTextInput)
  ]
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    defaults.register(defaults: ["showReference": true])
    
    if let splitViewController = self.parent as? NSSplitViewController {
      let showReferenceOnStartup = defaults.bool(forKey: "showReference")
      splitViewController.splitViewItems.last!.isCollapsed = !showReferenceOnStartup
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.themeChanged),
      name: NSNotification.Name(rawValue: "changeThemeNotification"),
      object: nil
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setThemeColor(notification: nil)
  }
  
  @objc func themeChanged(notification: Notification?) {
    setThemeColor(notification: notification)
    setRegexInputColor(notification: notification)
    parse()
  }
  
  func parse() {
    let attr = setRegexHighlight(
      regex: regexInput.textStorage?.string,
      text: self.textInput,
      event: nil
    )
    setOutputHighlight(attr: attr)
    setRegexInputColor(notification: nil)
  }
  
  // Set color for regex input when regex is syntax highlighted
  @objc func setRegexInputColor(notification: Notification?) {
    let theme = currentTheme.getTheme(notification)
    let highlightedText = highlighter.highlight(string: self.regexTextInput, theme: theme)
    let cursorPosition = regexInput.selectedRanges[0].rangeValue.location
    regexInput.textStorage?.mutableString.setString("")
    regexInput.textStorage?.append(highlightedText)
    regexInput.setSelectedRange(NSMakeRange(cursorPosition, 0))
  }
  
  @objc func setThemeColor(notification: Notification?) {
    let theme = currentTheme.getTheme(notification)
    if (theme == "Light") {
      topHalf.material = .light
      bottomHalf.material = .mediumLight
    } else {
      topHalf.material = .dark
      bottomHalf.material = .ultraDark
    }
    regexInput.textColor = currentTheme.text
    textOutput.textColor = currentTheme.text
    self.view.window?.appearance = NSAppearance(named: currentTheme.appearance)
    regexInput.font = NSFont(name: "Monaco", size: 15)
    textOutput.font = NSFont(name: "Monaco", size: 15)
  }
  
  func matches(for regex: String, in text: String) -> [NSTextCheckingResult] {
    do {
      invalidLabel.stringValue = ""
      let regex = try NSRegularExpression(pattern: regex, options: [])
      let results = regex.matches(
        in: text,
        options: [],
        range: NSRange(location: 0, length: text.count)
      )
      return results
    } catch _ {
      if (regex.count > 0) {
        invalidLabel.stringValue = "Expression is invalid"
      }
      return []
    }
  }
  
  func setOutputHighlight(attr: NSMutableAttributedString) {
    regexInput.textColor = currentTheme.text
    textOutput.textColor = currentTheme.text
    attr.addAttribute(
      NSAttributedStringKey.foregroundColor,
      value: currentTheme.text,
      range: NSRange(location: 0, length: attr.length)
    )
    
    let cursorPosition = textOutput.selectedRanges[0].rangeValue.location
    textOutput.textStorage?.mutableString.setString("")
    textOutput.textStorage?.append(attr)
    textOutput.setSelectedRange(NSMakeRange(cursorPosition, 0))
    textOutput.font = NSFont(name: "Monaco", size: 15)
  }
  
  func setRegexHighlight(regex regexInput: String?, text textInput: String?, event: NSEvent?) -> NSMutableAttributedString {
    let topBox = regexInput
    let bottomBox = textInput
    let theme = currentTheme.getTheme()
    
    if let topBox = topBox, let bottomBox = bottomBox {
      var foundMatches : [NSTextCheckingResult] = []
      
      // If backspace, drop backspace character from regex
      // Otherwise get topBox regex and current key character
      if let event = event {
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
          foundMatches = matches(for: String(topBox.dropLast()), in: bottomBox)
        } else {
          foundMatches = matches(for: topBox + String(describing: event.characters!), in: bottomBox)
        }
      } else {
        foundMatches = matches(for: topBox, in: bottomBox)
      }
      
      let attribute = NSMutableAttributedString(string: bottomBox)
      let attributeLength = attribute.string.count
      
      var newColor = false
      
      for match in foundMatches {
        var range = match.range(at: 0)
        var index = bottomBox.index(bottomBox.startIndex, offsetBy: range.location + range.length)
        var outputStr = String(bottomBox[..<index])
        index = bottomBox.index(bottomBox.startIndex, offsetBy: range.location)
        outputStr = String(outputStr.suffix(from: index))
        let matchLength = outputStr.count
        
        let backgroundColor: NSColor;
        
        if (newColor) {
          if (theme == "Light") {
            backgroundColor = NSColor(red:0.86, green:0.58, blue:0.99, alpha:1.00)
          } else {
            backgroundColor = NSColor(red: 0.60, green: 0.26, blue: 0.77, alpha: 1)
          }
        } else {
          if (theme == "Light") {
            backgroundColor = NSColor(red:0.59, green:0.87, blue:0.97, alpha:1.00)
          } else {
            backgroundColor = NSColor(red: 0.25, green: 0.51, blue: 0.77, alpha: 1)
          }
        }
        
        attribute.addAttribute(
          NSAttributedStringKey.backgroundColor,
          value: backgroundColor,
          range: NSRange(location: range.location, length: matchLength)
        )
        
        range = NSMakeRange(range.location + range.length, attributeLength - (range.location + range.length))
        newColor = !newColor
      }
      return attribute
    }
    return NSMutableAttributedString(string: "")
  }

  @IBAction func referenceButtonClicked(_ sender: NSButton) {
    if let splitViewController = self.parent as? NSSplitViewController {
      let splitViewItem = splitViewController.splitViewItems
      
      splitViewItem.last!.collapseBehavior = .preferResizingSplitViewWithFixedSiblings
      splitViewItem.last!.animator().isCollapsed = !splitViewItem.last!.isCollapsed
    }
  }
  
}

