//
//  XcodeTool+Helpers.swift
//  XcodeTool
//
//  Created by Christophe Braud on 11/06/2017.
//  Base on Tof Templates (https://goo.gl/GdyFiw)
//  Copyright © 2017 Christophe Braud. All rights reserved.
//

import Foundation

// MARK: -
// MARK: XcodeTool extension
// MARK: -
public  extension XcodeTool {
  // MARK: -
  // MARK: Public access
  // MARK: -
  
  // MARK: -> Public enums
  
  // MARK: -> Public structs
  
  // MARK: -> Public class
  
  // MARK: --> Command template
  
  public class Source : Codable {
    public var uuid:String!
    public var name:String!
    public var source:String!
    public var templates:String!
    public var description:String!
    public var version:String? = nil
    public var author:String? = nil
  }
  
  public class Template : Codable {
    public var name:String!
    public var url:String!
    public var description:String!
    public var branch:String? = nil
    public var tag:String? = nil
    public var subfolder:String? = nil
    public var original:String? = nil
    public var protect:[String]? = nil
    public var author:String? = nil
    public var version:String? = nil
  }
  
  // MARK: --> Command markdown
  
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
  
  // MARK: --> Command template
  
  public static var pathRoot:String {
    return  applicationSupportDirectory + "XcodeTool/"
  }
  
  public static var pathSources:String {
   return  pathRoot + "Sources/"
  }
  
  public static var pathTemplates:String {
    return pathRoot + "Templates/"
  }
  
  public static var defaulfSources:[String] = ["XcodeTool"]
  
  // MARK: --> Command markdown
  
  // MARK: -> Public properties
  
  // MARK: -> Public class methods
  
  // MARK: --> Command template
  
  public class func gitClone(url pUrl:String, branch pBranch:String? = nil, tag pTag:String? = nil, target pTarget:String, display pDisplay:Bool) -> Int32 {
    var lRet:Int32 = -1
    
    guard let lGit = whereis("git") else {
      display(type: .no, format: "git not found")
      return lRet
    }
    
    let lShell = Shell()
    
    if pDisplay == true {
      lShell.run("'\(lGit)' clone --progress \"\(pUrl)\" \"\(pTarget)\"", readLine: {
        pLine in
        if pLine.contains("Receiving objects:") {
          print("git: \(pLine)\r")
        }
      })
    } else {
      lShell.run("git clone \"\(pUrl)\" \"\(pTarget)\"")
    }
    
    lRet = lShell.wait()
    
    if let lTag = pTag {
      lRet = lShell.run("cd \"\(pTarget)\" && git checkout tags/\(lTag)").wait()
    } else if let lBranch = pBranch {
      lRet = lShell.run("cd \"\(pTarget)\" && git checkout \(lBranch)").wait()
    }
    
    return lRet
  }
  
  public class func gitPull(path pPath:String) -> Int32 {
    guard let lGit = whereis("git") else {
      display(type: .no, format: "git not found")
      return -1
    }
    
    let lShell = Shell()
    
    lShell.run("cd \"\(pPath)\" && '\(lGit)' pull")
    
    return lShell.wait()
  }
  
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
        
        let lExit = gitClone(url: pPath, branch: pBranch, tag: pTag, target: lTmpXcodeTool, display: true)
        
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
  
  public class func patch(path pPath:String, original pOriginal:String, new pNew:String, protect pProtect:[String]? = nil) -> Bool {
    var lRet = true
    let lPath = pPath.hasSuffix("/") == false ? "\(pPath)/" : pPath
    
    let lRenamePath:(String) -> String? = {
      pPath in
      
      var lRet:String? = pPath
      let lName = fullname(path: pPath)
      
      if lName.contains(pOriginal) == true {
        lRet = dir(path: pPath) + lName.replace(search: pOriginal, with: pNew)
        
        if mv(at: pPath, to: lRet!) == false {
          lRet = nil
        }
      }
      
      return lRet
    }
    
    for lItem in glob(path: lPath) where lRet == true {
      if let lCurrent = lRenamePath(lItem) {
        if isDir(lCurrent) == true {
          lRet = patch(path: lCurrent, original: pOriginal, new: pNew, protect: pProtect)
        } else if ["xcuserdata", "podspec"].contains(ext(path: lCurrent)) {
          if isDir(lCurrent) == true {
            if rmdir(path: lCurrent) == false {
              display(type: .no, format: "Unable to purge user data")
              lRet = false
            }
          } else if rm(path: lCurrent) == false {
            display(type: .no, format: "Unable to remove '\(lCurrent)'")
            lRet = false
          }
        } else if isFile(lCurrent) && ["swift","h", "m", "plist", "pbxproj", "xcworkspacedata", "xcscheme"].contains(ext(path: lCurrent)) {
          if let lContent = readText(file: lCurrent) {
            var lProtects:[String:String] = [:]
            var lContentPatch = lContent
            
            if let lProtect = pProtect {
              let lUuids = lProtect.map({ _ in UUID().uuidString })
              lProtects = Dictionary(uniqueKeysWithValues: zip(lUuids, lProtect))
              
              for (lUuid, lValue) in lProtects {
                lContentPatch = lContentPatch.replace(search: lValue, with: lUuid)
              }
            }
            
            lContentPatch = lContentPatch.replace(search: pOriginal, with: pNew)
            
            if lProtects.count > 0 {
              for (lUuid, lValue) in lProtects {
                lContentPatch = lContentPatch.replace(search: lUuid, with: lValue)
              }
            }
            
            if lContentPatch != lContent {
              if writeText(file: lCurrent, string: lContentPatch) == false {
                display(type: .no, format: "Unable to patch '\(lItem)'")
                lRet = false
              }
            }
          }
        }
      } else {
        display(type: .no, format: "Unable to handle '\(lItem)'")
        lRet = false
      }
    }
    
    if lRet == true && lRenamePath(pPath) == nil {
      display(type: .no, format: "Unable to handle '\(pPath)'")
      lRet = false
    }
    
    return lRet
  }
  
  public class func initialize() -> Bool {
    var lRet = true
    
    if isDir(pathRoot) == false {
      if mkdir(path: pathSources, sub: true) == false {
        print("Error unable to initiliazed XcodeTool\n".cli.error)
        lRet = false
      }
      if mkdir(path: pathTemplates, sub: true) == false {
        print("Error unable to initiliazed XcodeTool\n".cli.error)
        lRet = false
      }
    }
    
    if lRet == true {
      let lDefaultUrl = "https://raw.githubusercontent.com/TofPlay/XcodeTool/master/Templates.json"
      let lPathDefaultSource = pathSources + "XcodeTool.json"
      var lRawSource:Source? = nil
      
      let lCheckDefaultSource:(Data?) -> Bool = {
        pData in
        
        var lRet = false
        
        if let lData = pData {
          do {
            let lSource = try JSONDecoder().decode(Source.self, from: lData)
            if lSource.uuid == "F0A12A62-AEA3-45B2-98C4-4D4410F53C37" && lSource.name == "XcodeTool" {
              lRet = writeData(file: lPathDefaultSource, data: lData)
              
              if lRet == true {
                lRawSource = lSource
              }
            }
          } catch let lError {
            self.error = lError
          }
        }
        
        return lRet
      }
      
      lRet = lCheckDefaultSource(readData(file: lPathDefaultSource))
      
      if lRet == false {
        lRet =  lCheckDefaultSource(readData(url: lDefaultUrl))
      }
      
      if let lSource = lRawSource, let lUuid = lSource.uuid, let lUrl = lSource.templates {
        let lSourceTemplates = pathTemplates + "\(lUuid)/"
        
        if exist(path: lSourceTemplates) {
          lRet = gitPull(path: lSourceTemplates) == 0
        } else {
          lRet = gitClone(url: lUrl, target: lSourceTemplates, display: false) == 0
        }
      }
    }
    
    if let lDefaultSource = readLines(file: pathSources + ".default") {
      defaulfSources = lDefaultSource
    } else {
      error = nil
      if writeText(file: pathSources + ".default", string: "XcodeTool\n") == false {
        error = nil
      }
    }
    
    return lRet
  }
  
  public class func source(file pFile:String) -> Source? {
    var lRet:Source? = nil
    
    if let lData = readData(file: pFile) {
      do {
        lRet = try JSONDecoder().decode(Source.self, from: lData)
      } catch let lError {
        self.error = lError
      }
    }
    
    return lRet
  }
  
  public class func source(url pUrl:String, save pSave:Bool=false) -> Source? {
    var lRet:Source? = nil
    var lUrl = pUrl
    
    if isFile(pUrl) {
      lUrl = "file://" + pUrl
    }
    
    if let lData = readData(url: lUrl) {
      do {
        lRet = try JSONDecoder().decode(Source.self, from: lData)
        if pSave == true, let lName = lRet?.name, let lUuid = lRet?.uuid, let lUrl = lRet?.templates {
          let lPathSource = pathSources + "\(lName).json"
          let lPathTemplates = pathTemplates + "\(lUuid)/"
          
          if writeData(file: lPathSource, data: lData) == false {
            lRet = nil
          } else {
            if isDir(lPathTemplates) {
              if gitPull(path: lPathTemplates) != 0 {
                lRet = nil
              }
            } else {
              if gitClone(url: lUrl, target: lPathTemplates, display: false) != 0 {
                lRet = nil
              }
            }
          }
        }
      } catch let lError {
        self.error = lError
      }
    }
    
    return lRet
  }
  
  public class func source(name pName:String) -> Source? {
    let lPathSource = pathSources + "\(pName).json"
    return source(file: lPathSource)
  }
  
  public class func template(file pFile:String) -> Template? {
    var lRet:Template? = nil
    
    if let lData = readData(file: pFile) {
      do {
        lRet = try JSONDecoder().decode(Template.self, from: lData)
      } catch let lError {
        self.error = lError
      }
    }
    
    return lRet
  }
  
  public class func sources() -> [Source] {
    var lRet:[Source] = []
    
    for lFile in glob(path: pathSources + ".*\\.json", absPath: true) {
      if let lSource = source(file: lFile) {
        lRet.append(lSource)
      }
    }
    
    return lRet
  }
  
  public class func templates(source pSource:String? = nil) -> [Template] {
    var lRet:[Template] = []
    
    var lPathTemplates = pathTemplates
    
    if let lName = pSource, let lSource = source(file: pathSources + lName + ".json"), let lUuid = lSource.uuid {
      lPathTemplates += lUuid + "/.*\\.json"
    }
    
    for lFile in glob(path: lPathTemplates, absPath: true) {
      if let lTemplate = template(file: lFile) {
        lRet.append(lTemplate)
      }
    }
    
    return lRet
  }
  
  public class func templates(sources pSources:[String]) -> [Template] {
    var lRet:[Template] = []
    
    for lSource in pSources {
      lRet.append(contentsOf: templates(source: lSource))
    }
    
    return lRet
  }
  
  // MARK: --> Command markdown
  
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
  
  // MARK: -> Public implementation protocol <#protocol name#>
  
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
  
  // MARK: -> Internal implementation protocol <#protocol name#>
  
  // MARK: -
  // MARK: File Private access
  // MARK: -
  
  // MARK: -> File Private enums
  
  // MARK: -> File Private structs
  
  // MARK: -> File Private class
  
  // MARK: -> File Private type alias 

  // MARK: -> File Private static properties

  // MARK: -> File Private properties
  
  // MARK: -> File Private class methods
  
  // MARK: -> File Private init methods
  
  // MARK: -> File Private operators

  // MARK: -> File Private methods

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
