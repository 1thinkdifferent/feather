//
//  RegexHighlighter.swift
//  Regxr
//
//  Created by Luka Kerr on 25/9/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class RegexHighlighter {
  func highlight(string: String, theme: String) -> NSMutableAttributedString {
    let purpleFoundMatches = matches(
      for: "\\(|\\)|\\?|\\+|\\*|\\^|\\{|\\}|\\||\\.|\\^|\\$|\\\\",
      in: string
    )
    let blueFoundMatches = matches(
      for: "\\\\w|\\\\t|\\\\n|\\\\d|\\\\s|\\[|\\]|\\\\D|\\\\S|\\\\W",
      in: string
    )
    
    let attribute = NSMutableAttributedString(string: string)
    attribute.withColor(currentTheme.text)
    
    for match in purpleFoundMatches {
      let range = match.range(at: 0)
      var index = string.index(string.startIndex, offsetBy: range.location + range.length)
      var outputStr = String(string[..<index])
      index = string.index(string.startIndex, offsetBy: range.location)
      outputStr = String(outputStr.suffix(from: index))
      
      attribute.withColor(currentTheme.purple, at: NSRange(location: range.location, length: outputStr.count))
    }
    
    for match in blueFoundMatches {
      let range = match.range(at: 0)
      var index = string.index(string.startIndex, offsetBy: range.location + range.length)
      var outputStr = String(string[..<index])
      index = string.index(string.startIndex, offsetBy: range.location)
      outputStr = String(outputStr.suffix(from: index))
      
      attribute.withColor(currentTheme.blue, at: NSRange(location: range.location, length: outputStr.count))
    }
    
    attribute.withFont(NSFont(name: "Monaco", size: 15)!)
    return attribute
  }
  
  func matches(for regex: String, in text: String) -> [NSTextCheckingResult] {
    do {
      let regex = try NSRegularExpression(pattern: regex, options: [])
      return regex.matches(
        in: text,
        options: [],
        range: NSRange(location: 0, length: text.count)
      )
    } catch _ {
      return []
    }
  }
}
