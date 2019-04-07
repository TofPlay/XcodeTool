//
//  XcodeTool+Git.swift
//  XcodeTool
//
//  Created by Christophe Braud on 15/12/2018.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//  Copyright © 2018 Christophe Braud. All rights reserved.
//

import Foundation

// MARK: -
// MARK: XcodeTool extension
// MARK: -
extension XcodeTool {
  // MARK: -
  // MARK: XcodeTool.Git
  // MARK: -
  public class Git {
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
    
    public class func submodule(path pPath:String, source pSource:String, replace pReplace:String) -> Bool {
      var lRet:Bool = false
      
      let lCurrentDir = workdir()
      
      defer {
        if exist(path: ".git.backup") {
          if lRet == false {
            rmdir(path: ".git")
            rm(path: ".gitmodules")
            mv(at: ".git.backup", to: ".git")
            mv(at: ".gitmodules.backup", to: ".gitmodules")
          } else {
            rmdir(path: ".git.backup")
            rm(path: ".gitmodules.backup")
          }
        }
        chdir(path: lCurrentDir)
      }
      
      guard let lGit = whereis("git") else {
        display(type: .no, format: "git not found")
        return lRet
      }
      
      if chdir(path: pPath) == false {
        display(type: .no, format: "folder '\(pPath)' invalid")
        return lRet
      }
      
      if exist(path: ".git") && !exist(path: ".git.backup") {
        cp(path: ".git", to: ".git.backup")
      }
      
      if exist(path: ".gitmodules") == false {
        display(type: .no, format: "git: no submodules")
        return lRet
      } else if !exist(path: ".gitmodules.backup") {
        cp(path: ".gitmodules", to: ".gitmodules.backup")
      }
      
      var lUrl = ""
      var lBranch = ""
      
      if let lLines = readLines(file: ".gitmodules") {
        var lFound = false
        
        for lLine in lLines {
          if lFound {
            if let lVal = lLine.replace(regEx: "\\s*url = (.*)", template: "$1") {
              lUrl = lVal.trim().replace(string: pSource, sub: pReplace)
            }
            if let lVal = lLine.replace(regEx: "\\s*branch = (.*)", template: "$1") {
              lBranch = "-b " + lVal.trim()
            }
          } else {
            if lLine == "[submodule \"\(pSource)\"]" {
              lFound = true
            }
          }
        }
      }
      
      if lUrl.isEmpty == false {
        let lShell = Shell()
        
        lRet = lShell.run("\(lGit) rm --cached \(pSource)").wait() == 0
        
        if lRet == false {
          display(type: .no, format: "git: unable to rename submodule '\(pSource)' to '\(pReplace)'")
        } else {
          var lGlob:[String] = []
          
          lGlob.append(norm(path: pSource) + ".git")
          lGlob.append(norm(path: pSource))
          lGlob.append(".gitmodules")
          lGlob.append(".git/config")
          lGlob.append(".git/modules/\(pSource)/config")
          lGlob.append(".git/modules/\(pSource)/")
          
          lRet = Patch(original: pSource, new: pReplace).apply(glob: lGlob)
          
          if lRet == false {
            display(type: .no, format: "git: unable to rename submodule '\(pSource)' to '\(pReplace)'")
          } else {
            lRet = lShell.run("\(lGit) submodule add \(lBranch) \(lUrl) \(pReplace)").wait() == 0
            
            if lRet == false {
              display(type: .no, format: "git: unable to rename submodule '\(pSource)' to '\(pReplace)'")
            }
          }
        }
      } else {
        display(type: .no, format: "git: submodule '\(pSource)' not found")
      }
      
      return lRet
    }
    
    public class func set(path pPath:String, url pUrl:String? = nil, project pProject:String? = nil) -> Int32 {
      var lRet:Int32 = -1
      
      let lCurrentDir = workdir()
      
      defer {
        if exist(path: ".git.backup") {
          if lRet != 0 {
            rmdir(path: ".git")
            mv(at: ".git.backup", to: ".git")
          } else {
            rmdir(path: ".git.backup")
          }
        }
        chdir(path: lCurrentDir)
      }
      
      guard let lGit = whereis("git") else {
        display(type: .no, format: "git not found")
        return lRet
      }
      
      if chdir(path: pPath) == false {
        display(type: .no, format: "folder '\(pPath)' invalid")
        return lRet
      }
      
      var lProject = pProject
      
      if pUrl == nil && pProject == nil {
        lProject = pPath.lastWord()
      }
      
      if exist(path: ".git") && !exist(path: ".git.backup") {
        cp(path: ".git", to: ".git.backup")
      }
      
      var lOriginal = ""
      
      let lShell = Shell()
      
      lShell.run("\(lGit) remote -v") {
        pLine in
        
        if let lUrl = pLine.replace(regEx: "^origin\\s*([^ ]*)\\s*[(]fetch[)]", template: "$1") {
          lOriginal = lUrl
        }
      }
      
      lRet = lShell.wait()
      
      if lRet == 0 {
        var lNewUrl = ""
        
        if let lSetUrl = pUrl {
          lNewUrl = lSetUrl
        } else if let lRepo = lProject, let lBaseUrl = lOriginal.withoutLastWord("/") {
          lNewUrl = lBaseUrl + "/" + lRepo
        }
        
        if lNewUrl.isEmpty == false {
          lRet = lShell.run("\(lGit) remote set-url --add origin \(lNewUrl)").wait()
          
          if lRet != 0 {
            display(type: .no, format: "git: unable to set new url '\(lNewUrl)'")
          } else {
            lRet = lShell.run("\(lGit) remote set-url --del origin \(lOriginal)").wait()
            
            if lRet != 0 {
              display(type: .no, format: "git: unable to set new url '\(lNewUrl)'")
            }
          }
        }
      }
      return lRet
    }
    
    public class func clone(url pUrl:String, branch pBranch:String? = nil, tag pTag:String? = nil, target pTarget:String, display pDisplay:Bool) -> Int32 {
      var lRet:Int32 = -1
      
      guard let lGit = whereis("git") else {
        if pDisplay {display(type: .no, format: "git not found")}
        return lRet
      }
      
      let lShell = Shell()
      
      if pDisplay == true {
        lShell.run("'\(lGit)' clone --progress \"\(pUrl)\" \"\(pTarget)\"", readLine: {
          pLine in
          if pLine.contains("Receiving objects:") {
            display(type: .compute, format: "git: %@", pLine)
          }
        })
      } else {
        lShell.run("'\(lGit)' clone \"\(pUrl)\" \"\(pTarget)\"")
      }
      
      lRet = lShell.wait()
      
      if let lBranch = pBranch {
        lRet = lShell.run("cd \"\(pTarget)\" && '\(lGit)' checkout \(lBranch)").wait()
      } else if let lTag = pTag {
        lRet = lShell.run("cd \"\(pTarget)\" && '\(lGit)' checkout tags/\(lTag)").wait()
      } 
      
      return lRet
    }
    
    public class func pull(path pPath:String) -> Int32 {
      guard let lGit = whereis("git") else {
        return -1
      }
      
      return Shell().run("cd \"\(pPath)\" && '\(lGit)' pull").wait()
    }
    
    @discardableResult
    public class func checkout(path pPath:String, branch pBranch:String? = nil, tag pTag:String? = nil) -> Bool {
      var lRet = false
      
      guard let lGit = whereis("git") else {
        return lRet
      }

      let lShell = Shell()

      if isDir(pPath) {
        if let lBranch = pBranch {
          lRet = lShell.run("cd \"\(pPath)\" && '\(lGit)' checkout \(lBranch)").wait() == 0
        } else if let lTag = pTag {
          lRet = lShell.run("cd \"\(pPath)\" && '\(lGit)' checkout tags/\(lTag)").wait() == 0
        }
      }
      
      return lRet
    }
    
    public class func tags(path pPath:String) -> [String]? {
      var lRet:[String]? = nil
      
      guard let lGit = whereis("git") else {
        return lRet
      }

      let lShell = Shell()

      if lShell.run("cd \"\(pPath)\" && '\(lGit)' tag").wait() == 0 {
        let lTags = lShell.stdout.filter({$0.isEmpty == false})
        if lTags.count > 0 { lRet = lTags }
      }
      
      return lRet
    }
    
    public class func tags(url pUrl:String) -> [String]? {
      var lRet:[String]? = nil
      
      guard let lGit = whereis("git") else {
        return lRet
      }
      
      let lShell = Shell()
      
      if lShell.run("'\(lGit)' ls-remote --tags \"\(pUrl)\"").wait() == 0 {
        let lTags = lShell.stdout.compactMap({$0.replace(regEx: ".*refs/tags/(.*)", template: "$1")})
        if lTags.count > 0 {lRet = lTags}
      }
      
      return lRet
    }

    @discardableResult
    public class func tags(path pPath:String,origin pOrigin:String) -> Bool {
      guard let lGit = whereis("git") else {
        return false
      }
      
      let lRet = Shell().run("cd \"\(pPath)\" && '\(lGit)' fetch --prune \(pOrigin) \"+refs/tags/*:refs/tags/*\"").wait() == 0
      
      return lRet
    }
    
    public class func remoteUrl(path pPath:String, repo pRepo:String = "origin") -> String? {
      var lRet:String? = nil
      
      guard let lGit = whereis("git") else {
        return lRet
      }
      
      let lShell = Shell()
      
      if lShell.run("cd \"\(pPath)\" && '\(lGit)' config --get remote.\(pRepo).url").wait() == 0 {
        lRet = lShell.stdout.first
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
    
    // MARK: -> Internal class methods
    
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

