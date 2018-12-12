//
//  XcodeTool+CmdMarkdown.swift
//  XcodeTool
//
//  Created by Christophe Braud on 09/12/2018.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//  Copyright © 2017 Christophe Braud. All rights reserved.
//

import Foundation

// MARK: -
// MARK: XcodeTool extension
// MARK: -
public extension XcodeTool {
  
  public class CmdMarkdown {
    
    // MARK: -
    // MARK: Public access
    // MARK: -
    
    // MARK: -> Public enums
    
    // MARK: -> Public structs
    
    // MARK: -> Public class
    
    // MARK: -> Public type alias
    
    // MARK: -> Public static properties
    
    // MARK: -> Public properties
    
    // MARK: -> Public class methods
    
    public class func root(_ pVars:[String:String]) {
        
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Markdown")
        
        defer {
            display(type: .done)
        }
        
        guard var lFolder = pVars["folder"], lFolder.isEmpty == false else {
            display(type: .no, format: "parameter <folder> invalid or missing")
            return
        }
        
        var lParent = dir(path: lFolder)
        
        if lParent.isEmpty {
            lParent = workdir()
            lFolder = lParent + lFolder
        }
        
        lFolder = norm(path: lFolder)
        
        let lDoc = pVars["docs"] ?? norm(path:lParent) + "Docs/"
        let lOne = pVars["one"] ?? ""
        let lMain = pVars["main"] ?? ""
        var lMarkdownMain = ""
        
        if exist(path: lDoc) == false {
            if mkdir(path: lDoc) == false {
                display(type: .no, format: "unable to create '\(lDoc)'")
                return
            }
        }
        
        if chdir(path: lFolder) == false {
            display(type: .no, format: "folder '\(lFolder)' not found")
            return
        }
        
        let lFiles = glob(path: lFolder + ".*\\.swift", recursive: true)
        
        if lFiles.count > 0 {
            var lCpt = 0
            
            Markdown.stack = []
            Markdown.items = []
            
            display(type: .compute, format: "processing 0/\(lFiles.count)...")
            
            for lFile in lFiles {
                lCpt += 1
                
                display(type: .compute, format: "processing \(lCpt)/\(lFiles.count)...")
                
                var lLevel = 0
                
                if var lLines = readLines(file: lFile) {
                    var lComments:[String] = []
                    var lLongComments = false
                    
                    while lLines.count > 0 {
                        var lLine = lLines.removeFirst()
                        
                        // Extract markdown in comments
                        if let lExtract = lLine.extract(regEx: "\\s*///(.*)").first, lLongComments == false {
                            lComments.append(lExtract)
                        } else {
                            
                            // Ignore text multi-lines
                            if lLine.contains("\"\"\"") {
                                lLongComments = !lLongComments
                                continue
                            } else {
                                if lLongComments {
                                    continue
                                }
                            }
                            
                            // Sub-section detected
                            let lInsts = lLine.extract(regEx: "\\s*//\\s*XT([^\\s]*)\\s*:\\s*(.*)")
                            
                            if lInsts.count == 2 {
                                let lType = lInsts[0]
                                let lSubSection = lInsts[1]
                                let lItem = Markdown(level: lLevel, summary: lSubSection.trim(), markdown: [])
                                
                                switch lType {
                                case "U":
                                    lItem.subSection = .up
                                case "D":
                                    lItem.subSection = .down
                                default:
                                    lItem.subSection = .same
                                }
                                
                                if let lParent = Markdown.stack.last {
                                    lParent.items.append(lItem)
                                } else {
                                    if let lLast = Markdown.items.last {
                                        if lLast.section {
                                            lLast.items.append(lItem)
                                        } else {
                                            Markdown.items.append(lItem)
                                        }
                                    }
                                }
                            }
                            
                            // Ignore double quote
                            if let lLineWithoutQuote = lLine.replace(regEx: "\\\\\"", template: "") {
                                lLine = lLineWithoutQuote
                            }
                            
                            // Ignore text
                            if let lLineWithoutText = lLine.replace(regEx: "\\\".*\\\"", template: "\\\"\\\"") {
                                lLine = lLineWithoutText
                            }
                            
                            // Ignore comments
                            if let lLineWithoutComment = lLine.replace(regEx: "//.*", template: "") {
                                lLine = lLineWithoutComment
                            }
                            
                            if lLine.match(regEx: "extension |class |struct |enum |init\\s*\\(|deinit |subscript\\(|func |var |let ", partial: true) {
                                if lComments.isEmpty == false {
                                    var lMarkdown = lComments
                                    let lSummary = lMarkdown.removeFirst()
                                    
                                    lMarkdown.insert("`" + lLine.trim(" {") + "`", at: 0)
                                    
                                    let lItem = Markdown(level: lLevel, summary: lSummary, markdown: lMarkdown)
                                    
                                    if lLine.match(regEx: "extension |class |struct |enum ", partial: true) && lLine.contains("class func") == false {
                                        lItem.section = true
                                        lItem.level += 1
                                        if let lParent = Markdown.stack.last ?? Markdown.items.last {
                                            lParent.items.append(lItem)
                                        } else {
                                            Markdown.items.append(lItem)
                                        }
                                        Markdown.stack.append(lItem)
                                    } else {
                                        if let lParent = Markdown.stack.last {
                                            lParent.items.append(lItem)
                                        } else {
                                            if let lLast = Markdown.items.last {
                                                if lLast.section {
                                                    lLast.items.append(lItem)
                                                } else {
                                                    Markdown.items.append(lItem)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                lComments = []
                            }
                            
                            // Update level
                            let lOpen = lLine.extract(regEx: "(\\{)").count
                            let lClose = lLine.extract(regEx: "(\\})").count
                            
                            lLevel = lLevel + lOpen - lClose
                            
                            if let lLevelItem = Markdown.stack.last?.level, lLevel < lLevelItem {
                                Markdown.stack.removeLast()
                            }
                        }
                    }
                    
                    if lOne.isEmpty && Markdown.items.count > 0 {
                        let lName = name(path: lFile) + ".md"
                        let lMarkdownFile = lOne.isEmpty ? lDoc + lName : lOne
                        
                        if lMain.isEmpty == false {
                            if lMarkdownMain.isEmpty {
                                lMarkdownMain = "## Documentation\n\n"
                            }
                            
                            if let lFirstItem = Markdown.items.first {
                                lMarkdownMain += "- [\(lFirstItem.summary.trim())](\(lName))\n"
                            }
                        }
                        
                        generate(file:lMarkdownFile)
                    }
                    
                } else {
                    display(type: .no, format: "unable to read '\(lFile)'")
                }
            }
            
            display(type: .yes, format: "process \(lFiles.count) file%@", lFiles.count > 1 ? "s" : "")
            
            if !lOne.isEmpty && Markdown.items.count > 0 {
                generate(file:lOne)
            } else if !lMain.isEmpty {
                let lMainFile = "\(lDoc)\(lMain).md"
                
                if writeText(file: lMainFile, string: lMarkdownMain) == false {
                    display(type: .no, format: "unable to save '\(lMainFile)'")
                }
            }
        }
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
}

