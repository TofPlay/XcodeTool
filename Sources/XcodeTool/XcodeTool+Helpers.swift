//
//  XcodeTool+Helpers.swift
//  XcodeTool
//
//  Created by Christophe Braud on 11/06/2017.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//  Copyright © 2017 Christophe Braud. All rights reserved.
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
  
  // MARK: -> Public type alias
  
  // MARK: -> Public static properties
  
  // MARK: -> Public properties
  
  // MARK: -> Public class methods
    
  // MARK: --> Tools folder
  
  public class func copy(path pPath:String, branch pBranch:String? = nil, tag pTag:String? = nil, target pTarget: String, subfolder pSubfolder:String?) -> Bool {
    if exist(path: pTarget) == true {
      display(type: .yes, verbose: true, format: "remove previous target folder")
      
      if rmdir(path: pTarget) == false {
        display(type: .no, format: "unable to remove target folder '\(pTarget)'")
        return false
      }
    } else {
      display(type: .yes, verbose: true, format: "folder for target not found")
    }
    
    if exist(path: dir(path: pTarget)) == false {
      var lFolder = dir(path: pTarget)
      
      if lFolder.isEmpty {
        lFolder = pTarget
      }
      
      display(type: .yes, verbose: true, format: "create target folder")
      
      if mkdir(path: lFolder, sub: true) == false {
        display(type: .no, format: "unable to create folder '\(lFolder)'")
        return false
      }
    }
    
    if isDir(pPath) == true {
      var lPath = pPath
      
      display(type: .yes, verbose: true, format: "template is local file")
      
      if let lSubfolder = pSubfolder {
        if isDir(lPath  + "/\(lSubfolder)") == false {
          display(type: .no, format: "subfolder '\(lSubfolder)' not found in '\(lPath)'")
          return false
        }
        
        display(type: .yes, verbose: true, format: "subfolder found")
        
        lPath += "/\(lSubfolder)"
      }
      
      if cp(path: lPath, to: pTarget) == false {
        display(type: .no, format: "unable to copy path '\(pPath)' to target folder '\(pTarget)'")
        return false
      } else {
        display(type: .yes, verbose: true, format: "local template copy to target folder done")
      }
    } else {
      if pPath.hasPrefix("http://") || pPath.hasPrefix("https://") {
        
        guard whereis("git") != nil else {
          display(type: .no, format: "git not found")
          return false
        }
        
        var lTmpXcodeTool = self.tempDirectory + "XcodeTool"
        
        if isDir(lTmpXcodeTool) == false {
          display(type: .yes, verbose: true, format: "tempory folder doesn't exist")
          
          if mkdir(path: lTmpXcodeTool) == false {
            display(type: .no, format: "unable to create a new temporary folder '\(lTmpXcodeTool)'")
            return false
          } else {
            display(type: .yes, verbose: true, format: "create temporary folder")
          }
        }
        
        lTmpXcodeTool += "/\(name(path: pTarget))"
        
        if isDir(lTmpXcodeTool) == true {
          display(type: .yes, verbose: true, format: "temporary target folder exist")
          
          if rmdir(path: lTmpXcodeTool) == false {
            display(type: .no, format: "unable to remove temporary folder '\(lTmpXcodeTool)'")
            return false
          } else {
            display(type: .yes, verbose: true, format: "temporary target folder removed")
          }
        }
        
        let lExit = Git.clone(url: pPath, branch: pBranch, tag: pTag, target: lTmpXcodeTool, display: true)
        
        if lExit != 0 {
          display(type: .no, format: "git clone failed, error code \(lExit)")
          return false
        } else {
          display(type: .yes, verbose: true, format: "clone target done")
        }
        
        if let lSubfolder = pSubfolder {
          if isDir("\(lTmpXcodeTool)/\(lSubfolder)") == false {
            display(type: .no, format: "subfolder '\(lSubfolder)' not found in '\(lTmpXcodeTool)'")
            return false
          } else {
            display(type: .yes, verbose: true, format: "sub folder '\(lSubfolder)' found")
          }
          
          lTmpXcodeTool += "/\(lSubfolder)"
        }
        
        display(type: .yes, verbose: true, format: "check .git folder")
        
        if isDir(lTmpXcodeTool + "/.git") {
          display(type: .yes, verbose: true, format: ".git folder found")
          
          if rmdir(path: lTmpXcodeTool + "/.git") == false {
            display(type: .no, format: "unable to remove .git folder")
            return false
          } else {
            display(type: .yes, verbose: true, format: ".git folder removed")
          }
        }
        
        display(type: .yes, verbose: true, format: "copy temporary folder to target folder")
        
        if cp(path: lTmpXcodeTool, to: pTarget) == false {
          display(type: .no, format: "unable to copy temporary folder '\(lTmpXcodeTool)' to target folder '\(pTarget)'")
          return false
        }  else {
          display(type: .yes, verbose: true, format: "temporary folder copy to target folder done")
        }
        
      } else {
        display(type: .no, format: "path not recognized.")
        return false
      }
    }
    
    return true
  }
  
  public class func header(path pPath:String, createdBy pCreatedBy:String?, createdAt pCreatedAt:String?, copyRightYear pCopyRightYear:String?, copyRightName pCopyRightName:String?) -> Bool {
    var lRet = true
    
    if pCreatedBy != nil || pCreatedAt != nil || pCopyRightYear != nil || pCopyRightName != nil {
      let lWorkdir = workdir()
      
      if chdir(path: pPath) {
        let lFiles = glob(path: ".*\\.(h|swift)", recursive: true)
        
        for lCpt in 0..<lFiles.count  where lRet == true {
          let lFile = lFiles[lCpt]
          
          display(type: .compute, format: "header processing \(lCpt+1)/\(lFiles.count) file%@", lFiles.count > 1 ? "s" : "")
          
          if var lLines = readLines(file: lFile) {
            var lUpdated = false
            
            for lI in 0..<lLines.count {
              var lLine = lLines[lI]
              
              if lLine.isEmpty {
                break
              }
              
              if let lCreatedBy = pCreatedBy {
                if let lNew = lLine.replace(regEx: "//(\\s*)Created by [\\s\\w]*on (\\d*/\\d*/\\d*.*)", template: "//$1Created by \(lCreatedBy) on $2") {
                  lLines[lI] = lNew
                  lLine = lNew
                  lUpdated = true
                }
              }
              
              if let lCreatedAt = pCreatedAt {
                if let lNew = lLine.replace(regEx: "(//\\s*Created by [\\s\\w]*on) \\d*/\\d*/\\d*(.*)", template: "$1 \(lCreatedAt)$2") {
                  lLines[lI] = lNew
                  lLine = lNew
                  lUpdated = true
                }
              }
              
              if let lCopyRightYear = pCopyRightYear {
                if let lNew = lLine.replace(regEx: "(//\\s*Copyright ©) \\d* (.*)", template: "$1 \(lCopyRightYear) $2") {
                  lLines[lI] = lNew
                  lLine = lNew
                  lUpdated = true
                }
              }
              
              if let lCopyRightName = pCopyRightName {
                if let lNew = lLine.replace(regEx: "(//\\s*Copyright © \\d*) [^\\.]*. (.*)", template: "$1 \(lCopyRightName). $2") {
                  lLines[lI] = lNew
                  lLine = lNew
                  lUpdated = true
                }
              }
            }
            
            if lUpdated {
              if writeText(file: lFile, lines: lLines) == false {
                display(type: .warning, format: "header unable to save '\(lFile)'")
              }
            }
          }
        }
        
        chdir(path: lWorkdir)
      } else {
        lRet = false
      }
    }
    
    return lRet
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

