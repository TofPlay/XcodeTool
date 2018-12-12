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
        
        let lFile = pVars["file"] ?? workdir() + lName + ".json"
        let lSource = XcodeTool.Source()
        
        lSource.uuid = UUID().uuidString
        lSource.name = lName
        lSource.templates = lTemplates
        lSource.source = pVars["url"] ?? ""
        lSource.version = pVars["version"] ?? ""
        lSource.description = pVars["description"] ?? ""
        lSource.author = pVars["author"] ?? ""
        
        if let lJson = try? JSONEncoder().encode(lSource) {
          if writeData(file: lFile, data: lJson) == false {
            display(type: .no, format: "unable to save the json file")
          } else {
            display(type: .yes, format: "json file for the new source saved at '\(lFile)'")
          }
        } else {
          display(type: .no, format: "unable to generate the new source")
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
          display(type: .yes, format: "source \"\(lSource.name ?? "")\" added")
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
          var lLines = readLines(file: pathSources + ".default") ?? []
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
    
    public class func root(_ pVars:[String:String]) {
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
      
      guard var lTarget = pVars["target"], lTarget.isEmpty == false else {
        display(type: .no, format: "option --target is missing")
        return
      }
      
      if dir(path: lTarget).isEmpty {
        lTarget = workdir() + lTarget
      }
      
      display(type: .yes, verbose: true, format: "target '\(lTarget)'")
      
      let lNew = name(path: lTarget)
      
      guard lNew.isEmpty == false else {
        display(type: .no, format: "new project name not found")
        return
      }
      
      display(type: .yes, verbose: true, format: "new project name is: '\(lNew)'")
      
      let lXcode = pVars.keys.contains("xcode")
      let lSource = pVars["source"] ?? ""
      let lSources = lSource.isEmpty ? defaulfSources : [lSource]
      let lTemplates = templates(sources: lSources)
      let lList = (pVars["list"] ?? "Podfile,swift,h,m,storyboard,xib,md,plist,json,strings,png,pbxproj,xcworkspacedata,xcscheme,appiconset").components(separatedBy: ",")
      let lRemove = (pVars["remove"] ?? "xcuserdata,podspec").components(separatedBy: ",")
      let lIgnore = (pVars["ignore"] ?? "Pods,Carthage").components(separatedBy: ",")
      let lCreatedBy = pVars["createdBy"]
      let lCreatedAt = pVars["createdAt"]
      let lCopyRightYear = pVars["copyRightYear"]
      let lCopyRightName = pVars["copyRightName"]
      
      display(type: .compute, format: "checking if template '\(lName)' exist...")
      
      if let lTemplate = lTemplates.filter({ $0.name == lName }).first {
        let lProtect = pVars["protect"]?.components(separatedBy: ",") ?? lTemplate.protect

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
        
        guard let lOriginal = lTemplate.original, lOriginal.isEmpty == false else {
          display(type: .no, format: "original project name is missing")
          return
        }
        
        display(type: .yes, verbose: true, format: "original project name: '\(lOriginal)'")
        
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
          display(type: .yes, format: "template '\(lName)' duplicated")
          
          display(type: .compute, format: "patching template '\(lName)'...")
          
          if patch(path: lTarget, original: lOriginal, new: lNew, protect: lProtect, ignore: lIgnore, list: lList, remove: lRemove) == true {
            display(type: .yes, format: "template '\(lName)' patched")
          } else {
            display(type: .no, format: "patch aborted")
            return
          }
        } else {
          display(type: .no, format: "template aborted")
          return
        }
        
        if lCreatedBy != nil || lCreatedAt != nil || lCopyRightYear != nil || lCopyRightName != nil {
          if header(path: lTarget, createdBy: lCreatedBy, createdAt: lCreatedAt, copyRightYear: lCopyRightYear, copyRightName: lCopyRightName)  {
            display(type: .yes, format: "header processed")
          } else {
            display(type: .no, format: "header processing failed")
          }
        }
        
        if lXcode {
          if chdir(path: lTarget) {
            if glob(path: "[^\\.]*.xcodeproj").count == 0 {
              if let _ = whereis("swift") {
                if exist(path: "Package.swift") {
                  let lShell = Shell()
                  
                  display(type: .compute, format: "Xcode project generating...")
                  
                  if lShell.run("swift package generate-xcodeproj").wait() == 0 {
                    display(type: .yes, format: "Xcode project generated")
                  } else {
                    display(type: .no, format: "Xcode project aborted")
                  }
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
            display(type: .no, format: "target folder \"\(lTarget)\" not found or invalid")
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
      
      let lFile = pVars["file"] ?? workdir() + lName + ".json"
      let lTemplate = Template()
      
      lTemplate.name = lName
      lTemplate.url = lUrl
      lTemplate.description = pVars["description"] ?? ""
      lTemplate.original = pVars["original"] ?? ""
      lTemplate.branch = pVars["branch"] ?? ""
      lTemplate.tag = pVars["tag"] ?? ""
      lTemplate.protect = pVars["protect"]?.components(separatedBy: ",") ?? []
      lTemplate.version = pVars["version"] ?? ""
      lTemplate.author = pVars["author"] ?? ""
      
      if let lJson = try? JSONEncoder().encode(lTemplate) {
        if writeData(file: lFile, data: lJson) == false {
          display(type: .no, format: "unable to save the json file")
        } else {
          display(type: .yes, format: "json file for the new template saved at '\(lFile)'")
        }
      } else {
        display(type: .no, format: "unable to generate json file for the new template")
      }
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

