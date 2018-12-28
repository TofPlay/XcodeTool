//
//  XcodeTool+CmdTemplate.swift
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
  
  public class CmdTemplate {
    
    // MARK: -
    // MARK: Public access
    // MARK: -
    
    // MARK: -> Public enums
    
    // MARK: -> Public structs
    
    // MARK: -> Public class

    public class Source {
      
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
      public class func gen(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Source generate json")
        
        defer {
          display(type: .done)
        }
        
        guard let lName = pVars["name"], lName.isEmpty == false else {
          display(type: .no, format: "name of the new source is required")
          return
        }
        
        display(type: .yes, verbose: true, format: "name of the new source found")
        
        guard let lTemplates = pVars["templates"], lTemplates.isEmpty == false else {
          display(type: .no, format: "repository for templates missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "repository for templates found")
        
        let lFile = pVars["file"].unwrappedOr(default: workdir() + lName + ".json")
        let lSource = XcodeTool.Source()
        
        lSource.uuid = UUID().uuidString
        lSource.name = lName
        lSource.templates = lTemplates
        lSource.source = pVars["url"].unwrappedOr(default: "")
        lSource.description = pVars["description"].unwrappedOr(default: "")
        lSource.author = pVars["author"].unwrappedOr(default: "")
        
        if let lBranch = pVars["branch"] {
          lSource.branch = lBranch
        } else {
          if let lTag = pVars["tag"] {
            lSource.tag = lTag
          }
        }

        if writeJson(file: lFile, object: lSource) == false {
          display(type: .no, format: "unable to save the json file")
        } else {
          display(type: .yes, format: "json file for the new source saved at '\(lFile)'")
        }
      }
      
      public class func add(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Source add")
        
        defer {
          display(type: .done)
        }
        
        guard let lUrl = pVars["url"], lUrl.isEmpty == false else {
          display(type: .no, format: "parameter <url> is missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "url found")
        
        if let lSource = source(url: lUrl, save: true) {
          display(type: .yes, format: "source \"\(lSource.name.unwrappedOr(default: ""))\" added")
        } else {
          display(type: .no, format: "unable to add source with url \"\(lUrl)\"")
        }
      }
      
      public class func del(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Source del")
        
        defer {
          display(type: .done)
        }
        
        guard let lName = pVars["name"], lName.isEmpty == false else {
          display(type: .no, format: "parameter <name> is missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "name found")
        
        if let lSource = source(name: lName), let lUuid = lSource.uuid {
          let lPathSource = pathSources + "\(lName).json"
          let lPathTemplates = pathTemplates + lUuid
          
          rm(path: lPathSource)
          rmdir(path: lPathTemplates)
          
          display(type: .yes, format: "source \"\(lName)\" removed")
        } else {
          display(type: .no, format: "source \"\(lName)\" not found or invalid")
        }
      }
      
      public class func refresh(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Source refresh")
        
        defer {
          display(type: .done)
        }
        
        guard let lName = pVars["name"], lName.isEmpty == false else {
          display(type: .no, format: "parameter <name> is missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "name found")
        
        var lRefresh = false
        
        if let lSource = source(name: lName), let lUrl = lSource.source {
          lRefresh = source(url: lUrl, save: true) != nil
        }
        
        if lRefresh == false {
          display(type: .no, format: "can not refresh source \"\(lName)\", source not found or invalid")
        } else {
          display(type: .yes, format: "Refresh source \"\(lName)\" done")
        }
      }
      
      public class func `default`(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Source default")
        
        defer {
          display(type: .done)
        }
        
        guard let lName = pVars["name"], lName.isEmpty == false else {
          display(type: .no, format: "parameter <name> is missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "name found")
        
        let lDel = pVars.keys.contains("del")
        let lAdd = pVars.keys.contains("add") || lDel == false
        
        if lAdd {
          display(type: .yes, verbose: true, format: "add option found")
        } else if lDel {
          display(type: .yes, verbose: true, format: "del option found")
        }
        
        if let _ = source(name: lName) {
          let lAction = lAdd ? "added" : "removed"
          var lLines = readLines(file: pathSources + ".default").unwrappedOr(default: [])
          var lContinue = true
          
          if lAdd {
            if lLines.contains(lName) == false {
              display(type: .yes, verbose: true, format: "will add source \"\(lName)\"")
              lLines.append(lName)
            } else {
              display(type: .no, format: "source \"\(lName)\" already define as a default source")
              lContinue = false
            }
          } else if lDel {
            if lLines.contains(lName) == true {
              display(type: .yes, verbose: true, format: "will del source \"\(lName)\"")
              lLines = lLines.filter({ $0 != lName })
            } else {
              display(type: .no, format: "source \"\(lName)\" not define as a default source")
              lContinue = false
            }
          }
          
          if lContinue {
            if writeText(file: pathSources + ".default", lines: lLines) == false {
              display(type: .no, format: "source \"\(lName)\" not \(lAction) has a default source")
            } else {
              display(type: .yes, format: "source \"\(lName)\" \(lAction) has a default source")
            }
          }
        } else {
          display(type: .no, format: "source \"\(lName)\" not found or invalid")
        }
      }

      public class func ls(_ pVars:[String:String]) {
        let lSources = sources()
        
        print("\nSources available".cli.title + ":\n\n".cli.text)
        
        for lSource in lSources {
          if let lName = lSource.name, let lDescription = lSource.description {
            print(title:"  " + lName.cli.cmd + ": ".cli.text, description: lDescription.cli.text + "\n")
          }
        }
        
        let lDefaultSources = defaulfSources.joined(separator: ", ")
        let lPluriel = defaulfSources.count > 1 ? "s" : ""
        
        print("Default source\(lPluriel)".cli.title + ": \(lDefaultSources)\n\n".cli.text)
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
    
    // MARK: -> Public type alias
    
    // MARK: -> Public static properties
    
    // MARK: -> Public properties
    
    // MARK: -> Public class methods
    
    public class func apply(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      display(type: .action, format: "Template")
      
      defer {
        display(type: .done)
      }
      
      
      guard let lName = pVars["name"], lName.isEmpty == false  else {
        display(type: .no, format: "option --name must be specified")
        return
      }
      
      display(type: .yes, verbose: true, format: "template name: '\(lName)'")
      
      var lData:Data? = nil

      if let lFileAlias = pVars["alias"], lFileAlias.lastWord(".") == "json" {
        lData = readData(file: lFileAlias)
        
        guard lData != nil else {
          display(type: .no, format: "option --alias invalid json file")
          return
        }
      } else {
        if pVars["alias"] == nil {
          if let lCmdTarget = pVars["target"] {
            lData = "{\"TARGET\":\"\(lCmdTarget)\"}".data(using: .utf8)
          }

          guard lData != nil else {
            display(type: .no, format: "option --target or --alias must be specify")
            return
          }
        } else {
          lData = pVars["alias"]?.data(using: .utf8)

          guard lData != nil else {
            display(type: .no, format: "option --alias invalid json string")
            return
          }
        }
      }

      guard let lAlias = json2obj(lData) as? [String:String] else {
        display(type: .no, format: "option --alias is invalid")
        return
      }

      guard var lTarget = lAlias["TARGET"], lTarget.isEmpty == false else {
        display(type: .no, format: "alias \"TARGET\" is missing or empty")
        return
      }
      
      if dir(path: lTarget).isEmpty {
        lTarget = workdir() + lTarget
      }
      
      display(type: .yes, verbose: true, format: "new project name is: '\(lTarget)'")
      
      let lXcode = pVars.keys.contains("xcode") || lAlias["XCODE"] == "true"
      let lSource = pVars["source"].unwrappedOr(default: lAlias["SOURCE"].unwrappedOr(default: ""))
      let lSources = lSource.isEmpty ? defaulfSources : [lSource]
      let lTemplates = templates(sources: lSources)
      let lCreatedBy = pVars["createdBy"] ?? lAlias["CREATEDBY"]
      let lCreatedAt = pVars["createdAt"] ?? lAlias["CREATEDAT"]
      let lCopyRightYear = pVars["copyRightYear"] ?? lAlias["COPYRIGHTYEAR"]
      let lCopyRightName = pVars["copyRightName"] ?? lAlias["COPYRIGHTNAME"]
      
      display(type: .compute, format: "checking if template '\(lName)' exist...")
      
      if let lTemplate = lTemplates.filter({ $0.name == lName }).first {
        display(type: .yes, format: "template '\(lName)' exist")
        
        guard let lPath = lTemplate.url, lPath.isEmpty == false else {
          display(type: .no, format: "url is missing")
          return
        }
        
        if !(lPath.hasSuffix(".xtemplate") || lPath.hasSuffix(".xtemplate.git")) {
          display(type: .no, format: "invalid url for the template. Url must be finished by `.xtemplate` or `.xtemplate.git`")
          return
        }
        
        display(type: .yes, verbose: true, format: "url of the template: `\(lPath)`")
        
        let lBranch = pVars["branch"] ?? lTemplate.branch
        let lTag = pVars["tag"] ?? lTemplate.tag
        
        if lBranch != nil {
          display(type: .yes, verbose: true, format: "branch: '\(lBranch!)'")
        } else {
          if lTag != nil {
            display(type: .yes, verbose: true, format: "tag: '\(lTag!)'")
          }
        }
        
        let lSubfolder = lTemplate.subfolder
        
        if lSubfolder != nil {
          display(type: .yes, verbose: true, format: "sub-folder: '\(lSubfolder!)'")
        }
        
        display(type: .compute, verbose: true, format: "checking target...")
        
        if exist(path: lTarget) {
          display(type: .yes, format: "target folder valid")
        } else {
          if mkdir(path: lTarget, sub: true) == false {
            display(type: .no, format: "unable to create: '\(lTarget)'")
            return
          } else {
            display(type: .yes, format: "target folder created: '\(lTarget)'")
          }
        }
        
        if isDir(lPath) {
          display(type: .compute, format: "copying template '\(lName)'...")
        } else {
          display(type: .compute, format: "downloading template '\(lName)'...")
        }
        
        if copy(path: lPath, branch: lBranch, tag: lTag, target: lTarget, subfolder: lSubfolder) == true {
          var lPatch = Patch()

          if let lFile = lTemplate.patch {
            if chdir(path: lTarget) {
              if let lObj = readJson(codable: Patch.self, file: lFile) {
                lPatch = lObj

                lPatch.list.set(ifNil: Patch.Constant.list)
                lPatch.remove.set(ifNil: Patch.Constant.remove)
                lPatch.ignore.set(ifNil: Patch.Constant.ignore)
                lPatch.protect.set(ifNil: Patch.Constant.protect)

                guard let lPatchAlias = lPatch.alias else {
                  display(type: .yes, format: "missing alias key in %@", lFile.fg.c256(104))
                  return
                }
                
                let lMissingKeys = Set(lPatchAlias.keys).subtracting(Set(lAlias.keys))
                
                guard lMissingKeys.count == 0 else {
                  display(type: .yes, format: "missing alias [%@] %@ %@", lMissingKeys.joined(separator: ",").fg.c256(72),"key in".cli.text,lFile.fg.c256(104))
                  return
                }
                
                lPatch.alias = lAlias
                lPatch.ignore.remove(lFile)
                lPatch.remove.append(lFile)
                display(type: .yes, format: "use patch file %@", lFile.fg.c256(104))
              } else {
                display(type: .no, format: "json patch file %@ %@", lFile.fg.c256(104),"is missing".cli.text)
                return
              }
            }
          } else {
            guard let lOriginal = lTemplate.original, lOriginal.isEmpty == false else {
              display(type: .no, format: "original project name is missing")
              return
            }
            
            display(type: .yes, verbose: true, format: "original project name: '\(lOriginal)'")
            
            lPatch.list = pVars["list"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.list)
            lPatch.remove = pVars["remove"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.remove)
            lPatch.ignore = pVars["ignore"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.ignore)
            lPatch.protect = pVars["protect"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.protect)
            
            lPatch.add(original: lOriginal, new: lTarget)
          }
          
          display(type: .yes, format: "template '\(lName)' duplicated")
          
          display(type: .compute, format: "patching template '\(lName)'...")
          display(type: lPatch.apply(path: lTarget) ? .yes : .no, format: "template '\(lName)' patched")
        } else {
          display(type: .no, format: "template aborted")
          return
        }
        
        if lCreatedBy != nil || lCreatedAt != nil || lCopyRightYear != nil || lCopyRightName != nil {
          display(type:header(path: lTarget, createdBy: lCreatedBy, createdAt: lCreatedAt, copyRightYear: lCopyRightYear, copyRightName: lCopyRightName) ? .yes : .no, format: "header processed")
        }
        
        if lXcode {
          if chdir(path: lTarget) {
            if glob(path: "[^\\.]*.xcodeproj").count == 0 {
              if let _ = whereis("swift") {
                if exist(path: "Package.swift") {
                  let lShell = Shell()
                  
                  display(type: .compute, format: "Xcode project generating...")
                  display(type: lShell.run("swift package generate-xcodeproj").wait() == 0 ? .yes : .no, format: "Xcode project generated")
                } else {
                  display(type: .no, format: "\"Package.swift\" not found")
                }
              } else {
                display(type: .no, format: "SwiftPM not found")
              }
            } else {
              display(type: .warning, format: "Xcode project already exist")
            }
          } else {
            display(type: .no, format: "target folder \"\(lAlias)\" not found or invalid")
          }
        }
      } else {
        display(type: .no, format: "template \"\(lName)\" not found or invalid")
      }
    }
    
    public class func gen(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      display(type: .action, format: "Template generate json")
      
      defer {
        display(type: .done)
      }
      
      guard let lName = pVars["name"], lName.isEmpty == false else {
        display(type: .no, format: "name of the new template is required")
        return
      }
      
      display(type: .yes, verbose: true, format: "template's name found")
      
      guard let lUrl = pVars["url"], lUrl.isEmpty == false else {
        display(type: .no, format: "template's url missing")
        return
      }
      
      display(type: .yes, verbose: true, format: "template's url found")
      
      let lFile = pVars["file"].unwrappedOr(default: workdir() + lName + ".json")
      let lTemplate = Template()
      
      lTemplate.name = lName
      lTemplate.url = lUrl
      lTemplate.description = pVars["description"].unwrappedOr(default: "")
      lTemplate.branch = pVars["branch"].unwrappedOr(default: "")
      lTemplate.tag = pVars["tag"].unwrappedOr(default: "")
      lTemplate.patch = pVars["patch"].unwrappedOr(default: "XcodeTool.json")
      lTemplate.author = pVars["author"].unwrappedOr(default: "")

      display(type: writeJson(file: lFile, object: lTemplate) ? .yes : .no, format: "generate new template %@", lFile.fg.c256(104))
    }

    public class func patch(_ pVars:[String:String]) {
      Display.verbose = pVars.keys.contains("verbose")
      
      display(type: .action, format: "Generate json patch file for a template project")
      
      defer {
        display(type: .done)
      }

      guard let lFile = pVars["file"], lFile.isEmpty == false else {
        display(type: .no, format: "json file name is required")
        return
      }
      
      let lPatch = Patch()
      
      lPatch.list = Patch.Constant.list
      lPatch.remove = Patch.Constant.remove
      lPatch.ignore = Patch.Constant.ignore
      lPatch.protect = Patch.Constant.protect
      lPatch.alias = ["TARGET":"Template",
                      "XCODE":"false",
                      "SOURCE":"",
                      "CREATEDBY":"John Doe",
                      "CREATEDAT":"DD/MM/YYYY",
                      "COPYRIGHTYEAR":"YYYY",
                      "COPYRIGHTNAME":"Company"]
      lPatch.items = [
        Patch.Item(original: "Template", new: "$(TARGET)"),
        Patch.Item(enable: false, files: [Patch.Item.File(name: "SpecificFile1.swift")], original: "Template", new: "$(TARGET)"),
        Patch.Item(enable: false, files: [Patch.Item.File(name: "SpecificFile2.swift", continue: false, lines:[5,10,15,20])], original: "original", new: "$(NEW)")
      ]
      
      display(type:writeJson(file: lFile, object: lPatch) ? .yes : .no, format: "generate json %@", lFile.fg.c256(104))
    }

    public class func ls(_ pVars:[String:String]) {
      let lSource = pVars["source"] ?? ""
      let lSources = lSource.isEmpty ? defaulfSources : [lSource]
      let lTemplates = templates(sources: lSources)
      
      if lTemplates.count > 0 {
        print("\nTemplates available".cli.title + ":\n\n".cli.text)
        
        for lTemplate in lTemplates {
          if let lName = lTemplate.name, let lDescription = lTemplate.description {
            print(title:"  " + lName.cli.cmd + ": ".cli.text, description: lDescription.cli.text + "\n")
          }
        }
        
        print("\n")
      } else {
        display(type: .no, format: "Templates invalids or not template for \"\(lSource)\"")
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

