//
//  XcodeTool+Markdown.swift
//  XcodeTool
//
//  Created by Christophe Braud on 04/02/2018.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//
//

import Foundation

// MARK: -
// MARK: XcodeTool extension
// MARK: -
extension XcodeTool {
  // MARK: -
  // MARK: Public access
  // MARK: -
  
  // MARK: -> Public enums
  
  // MARK: -> Public structs
  
  // MARK: -> Public class
  
  public class Markdown {
    public enum SubSection {
      case none
      case same
      case up
      case down
    }
    public static var stack:[Markdown] = []
    public static var items:[Markdown] = []
    
    public var level:Int
    public var summary:String
    public var markdown:[String] = []
    public var items:[Markdown] = []
    public var section:Bool = false
    public var subSection:SubSection = .none
    
    init(level pLevel:Int, summary pSummary:String, markdown pMarkdown:[String]) {
      self.level = pLevel
      self.summary = pSummary
      self.markdown = pMarkdown
    }
  }
  
  // MARK: -> Public type alias
  
  // MARK: -> Public static properties
  
  // MARK: -> Public properties
  
  // MARK: -> Public class methods
  
  public class func generateMarkdown(items pItems:[Markdown], indent pIndent:Int = 0) -> String {
    var lRet = ""
    
    for lItem in pItems {
      
      if lItem.section {
        for lI in 0..<(lItem.markdown.count) {
          let lLine = lItem.markdown[lI]
          
          if lI == 0 {
            let lPad = String(repeating:"#", count: pIndent)
            lRet += "##\(lPad) \(lItem.summary.trim())\n\n"
            
            if lItem.summary.contains("extension") == false {
              lRet += "\(lLine)\n"
            }
          } else {
            lRet += "\(lLine)\n"
          }
        }
        
        lRet += "\n"
      } else if lItem.subSection != .none {
        var lIndent = pIndent
        
        switch lItem.subSection {
        case .down:
          if lIndent > 0 {
            lIndent -= 1
          }
        case .up:
          lIndent += 1
        default:
          break
        }
        
        let lPad = String(repeating:"#", count: lIndent)
        lRet += "##\(lPad) \(lItem.summary.trim())\n\n"
      } else {
        lRet += "<details>\n"
        lRet += "<summary>\(lItem.summary.trim())</summary>\n\n"
        for lLine in lItem.markdown {
          lRet += "\(lLine)\n"
        }
        lRet += "</details>\n\n"
      }
      
      if lItem.items.count > 0 {
        lRet += generateMarkdown(items: lItem.items, indent: pIndent + 1)
      }
    }
    
    return lRet
  }
  
  public class func generate(file pFile:String) -> Void {
    let lMarkdown = generateMarkdown(items: Markdown.items)
    
    if writeText(file: pFile, string: lMarkdown) == false {
      display(type: .no, format: "unable to save '\(pFile)'")
    }
    
    Markdown.stack = []
    Markdown.items = []
  }
  
  // MARK: -> Public init methods
  
  // MARK: -> Public operators
  
  // MARK: -> Public methods
  
  // MARK: -
  // MARK: Internal access (aka public for current module)
  // MARK: -
  
  // MARK: -> Internal enums
  
  // MARK: -> Internal structs
  
  // MARK: -> Internal class
  
  // MARK: -> Internal type alias
  
  // MARK: -> Internal static properties
  
  // MARK: -> Internal properties
  
  // MARK: -> Internal class methods
  
  // MARK: -> Internal init methods
  
  // MARK: -> Internal operators
  
  // MARK: -> Internal methods
  
  // MARK: -
  // MARK: Private access
  // MARK: -
  
  // MARK: -> Private enums
  
  // MARK: -> Private structs
  
  // MARK: -> Private class
  
  // MARK: -> Private type alias
  
  // MARK: -> Private static properties
  
  // MARK: -> Private properties
  
  // MARK: -> Private class methods
  
  // MARK: -> Private init methods
  
  // MARK: -> Private operators
  
  // MARK: -> Private methods
}

