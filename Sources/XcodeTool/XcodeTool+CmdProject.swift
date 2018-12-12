//
//  XcodeTool+CmdProject.swift
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
  
  public class CmdProject {
    
    public class func rename(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      display(type: .action, format: "Rename project")
      
      defer {
        display(type: .done)
      }
      
      guard let lNew = pVars["new"], lNew.isEmpty == false else {
        display(type: .no, format: "parameter <new> is missing")
        return
      }
      
      let lPath = abs(path: pVars["path"] ?? ".")
      let lOriginal = pVars["original"] ?? name(path: lPath)
      let lGit = pVars.keys.contains("git")
      let lGitSubmodule = pVars.keys.contains("submodule")
      let lList = (pVars["list"] ?? "Podfile,swift,h,m,storyboard,xib,md,plist,json,strings,png,pbxproj,xcworkspacedata,xcscheme,appiconset").components(separatedBy: ",")
      let lRemove = (pVars["remove"] ?? "xcuserdata,podspec").components(separatedBy: ",")
      let lIgnore = (pVars["ignore"] ?? "Pods,Carthage").components(separatedBy: ",")
      let lProtect = pVars["protect"]?.components(separatedBy: ",") ?? []
      let lCreatedBy = pVars["createdBy"]
      let lCreatedAt = pVars["createdAt"]
      let lCopyRightYear = pVars["copyRightYear"]
      let lCopyRightName = pVars["copyRightName"]
      
      if lOriginal == lNew {
        display(type: .no, format: "parameter <original> and <new> must be different")
        return
      }
      
      if lOriginal.isEmpty == false && lNew.isEmpty == false {
        if lGit == true {
          if gitSet(path: lPath, project: lNew) != 0 {
            display(type: .no, format: "git: unable to change url")
            return
          }
        }
        
        if lGitSubmodule == true {
          if gitSubmodule(path: lPath, source: lOriginal, replace: lNew) == false {
            display(type: .no, format: "git: unable to change submodules")
            return
          }
        }
        
        if patch(path: lPath, original: lOriginal, new: lNew, protect: lProtect, ignore: [".git"] + lIgnore, list: lList, remove: lRemove) == true {
          display(type: .yes, format: "rename '\(lOriginal)' to '\(lNew)' done")
        } else {
          display(type: .no, format: "rename '\(lOriginal)' to '\(lNew)' aborted")
          return
        }
        
        if lCreatedBy != nil || lCreatedAt != nil || lCopyRightYear != nil || lCopyRightName != nil {
          if header(path: lPath, createdBy: lCreatedBy, createdAt: lCreatedAt, copyRightYear: lCopyRightYear, copyRightName: lCopyRightName)  {
            display(type: .yes, format: "header processed")
          } else {
            display(type: .no, format: "header processing failed")
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
