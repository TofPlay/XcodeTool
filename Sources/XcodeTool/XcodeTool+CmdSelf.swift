//
//  XcodeTool+CmdSelf.swift
//  XcodeTool
//
//  Created by Christophe Braud on 19/12/2018.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//  Copyright © 2018 Christophe Braud. All rights reserved.
//

import Foundation

// MARK: -
// MARK: XcodeTool extension
// MARK: -
public extension XcodeTool {
  
  // MARK: -
  // MARK: CmdSelf
  // MARK: -
  public class CmdSelf {
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
    
    public class func update(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      Display.push(hidden: pVars["DISPLAY"] == "no",
        body: {
          let lTitle = pVars["TITLE"].unwrappedOr(default: "Update XcodeTool")
          
          display(type: .action, format: lTitle)
          
          guard let lSwift = whereis("swift") else {
            display(type: .no, verbose: true, format: "swift missing")
            return
          }
          
          let lRepository = pathRoot + "Repository"
          var lDone = false
          var lForce = false
          
          if isDir(lRepository) {
            let lRemoteUrl = Git.remoteUrl(path: lRepository).unwrappedOr(default: "").trimEnd(".git")
            let lAppUrl = xcodeToolRepository
            
            if let lTags = Git.tags(path: lRepository) {
              lDone = lAppUrl.hasPrefix(lRemoteUrl) == true && lTags.contains(xcodeToolVersion)
            }
            
          }
          
          if lDone == false {
            let lWorkdir = workdir()
            
            mkdir(path: pathRoot, sub: true)
            lDone = chdir(path: pathRoot)
            display(type: lDone ? .yes : .no, verbose: true, format: "chdir to root")
            
            if lDone {
              rmdir(path: lRepository)
              lDone = Git.clone(url: xcodeToolRepository, tag: xcodeToolVersion, target: lRepository, display: false) == 0
              display(type: lDone ? .yes : .no, verbose: true, format: "git clone repository to tag \(xcodeToolVersion)")
              lForce = true
              chdir(path: lWorkdir)
            }
          }
          
          if let lLatest = Git.tags(path: lRepository)?.last {
            display(type: .yes, verbose: true, format: "git latest local tag \(lLatest)")
            
            lDone = lLatest.version(greaterThan: xcodeToolVersion)
            
            if lDone || lForce {
              lDone = Git.checkout(path: lRepository, branch: "master")
              display(type: lDone ? .yes : .no, verbose: true, format: "git checkout to master")
              
              if lDone {
                lDone = Git.pull(path: lRepository) == 0
                display(type: lDone ? .yes : .no, verbose: true, format: "git pull latest version")
                
                if lDone {
                  lDone = Git.checkout(path: lRepository, tag: lLatest)
                  display(type: lDone ? .yes : .no, verbose: true, format: "git checkout to tag \(lLatest)")
                  
                  if lDone {
                    let lShell = Shell()
                    var lBinary = ""
                    
                    if Display.verbose == false {display(type: .compute, format: "building repository...")}
                    
                    display(type: lShell.run("cd \"\(lRepository)\" && rm -rf .build/ Package.resolved").wait() == 0 ? .yes : .no, verbose: true, format: "clean previous build")
                    display(type: .msg, verbose: true, format: "swift build -c release")
                    
                    lShell.run("cd \"\(lRepository)\" && '\(lSwift)' build -c release") {
                      pLine in
                      
                      display(type: .trace, verbose: true, format: pLine)
                      
                      if let lPath = pLine.replace(regEx: "Linking .(.*)", template: "$1") {
                        lBinary = lRepository + lPath
                      }
                    }
                    
                    lDone = lShell.wait() == 0 && lBinary.isEmpty == false
                    display(type: lDone ? .yes : .no, format: "repository builded")
                    
                    if lDone {
                      rm(path: "/usr/local/bin/XcodeTool")
                      lDone = cp(path: lBinary, to: "/usr/local/bin/XcodeTool")
                    }
                    
                    display(type: lDone ? .yes : .no, verbose: true, format: "copy version \(lLatest) to /usr/local/bin/XcodeTool")
                  }
                } else {
                  if let lTags = Git.tags(path: lRepository) {
                    for lTag in lTags.reversed() {
                      if Git.checkout(path: lRepository, tag: lTag) {
                        break
                      }
                    }
                  }
                }
              }
            } else {
              lDone = true
              display(type: .yes, format: "already with the latest version")
            }
          } else {
            lDone = false
            display(type: .no, verbose: true, format: "get latest tag")
          }
          
          display(type: lDone ? .yes : .no, format: "update done")
        },
        defer: {
          display(type: .done)
        })
    }
    
    public class func reset(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      Display.push(hidden: pVars["DISPLAY"] == "no",
        body: {
          display(type: .action, format: "Reset default sources and templates")
          
          let lPathDefaultSource = pathSources + "XcodeTool.json"
          
          mkdir(path: pathSources, sub: true)
          mkdir(path: pathTemplates, sub: true)
          
          display(type: .compute, format: "load default source")
    
          if let lSource = readJson(codable: Source.self, url: xcodeToolDefaultTemplates) {
            let lDefaultTempates = pathTemplates + lSource.uuid
            var lDone = false
            
            let lBackupSource = cp(path: lPathDefaultSource, to: lPathDefaultSource + ".old", overwrite: true)
            display(type: lBackupSource ? .yes : .no, format: "created a backup of default source")

            let lBackupTemplates = cp(path: lDefaultTempates, to: lDefaultTempates + ".old", overwrite: true)
            display(type: lBackupTemplates ? .yes : .no, format: "created a backup of previous templates")

            if lBackupSource && lBackupTemplates {
              lDone = writeJson(file: lPathDefaultSource, object: lSource)
              display(type: lDone ? .yes : .no, format: "installed latest default source")
              
              if lDone {
                lDone = Git.clone(url: lSource.templates, branch: lSource.branch, tag: lSource.tag, target: lDefaultTempates, display: false) == 0
                display(type: lDone ? .yes : .no, format: "installed latest default templates")
              }
            }
            
            if lDone {
              rm(path: lPathDefaultSource + ".old")
              rmdir(path: lDefaultTempates + ".old")
            } else {
              if lBackupSource {
                lDone = mv(at: lPathDefaultSource + ".old", to: lPathDefaultSource, overwrite: true)
                display(type: lDone ? .yes : .no, format: "restored previous default source")
              }

              if lBackupTemplates {
                lDone = mv(at: lDefaultTempates + ".old", to: lDefaultTempates, overwrite: true)
                display(type: lDone ? .yes : .no, format: "restored previous default templates")
              }
            }
          } else {
            display(type: .no, format: "loaded latest default source")
          }
        },
        defer: {
          display(type: .done)
        })
    }
    
    public class func install(_ pVars:[String:String]) {
      var lVars = pVars
      
      lVars["TITLE"] = "Clean install XcodeTool"
      rmdir(path: pathRoot + "Repository")
      update(lVars)
    }

    public class func uninstall(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      display(type: .action, format: "Uninstall XcodeTool")
      
      defer {
        display(type: .done)
      }
      
      if isDir(pathRoot) {
        display(type: rmdir(path: pathRoot) ? .yes : .no, format: "clean existing sources and templates")
      }
 
      if let lXcodeTool = whereis("XcodeTool") {
        display(type: rm(path: lXcodeTool) ? .yes : .no, format: "remove XcodeTool")
      } else {
        display(type: .msg, format: "XcodeTool not found")
      }
      
    }
    
    public class func initialize() -> Bool {
      var lRet = exist(path: pathSources)
      
      if lRet {
        let lPathDefaultSources = pathSources + "XcodeTool.json"

        if let lSource = readJson(codable: Source.self, file: lPathDefaultSources) {
          XcodeTool.version.source = lSource.branch ?? lSource.tag ?? "master"
          XcodeTool.version.remote = (Git.tags(url: xcodeToolRepository)?.last).unwrappedOr(default: "")
          
          lRet = XcodeTool.version.source == XcodeTool.version.progam

          if lRet {
            if let lDefaultSource = readLines(file: pathSources + ".default")?.filter({$0.isEmpty == false}) {
              defaulfSources = lDefaultSource
            } else {
              error = nil
              if writeText(file: pathSources + ".default", lines: ["XcodeTool"]) == false {
                error = nil
              }
            }
          }
        } else {
          lRet = false
        }
      }
      
      if lRet == false {
        print("Auto update XcodeTool\n")
        CmdSelf.update(["DISPLAY":"no"])
        CmdSelf.reset(["DISPLAY":"no"])
        lRet = initialize()
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


