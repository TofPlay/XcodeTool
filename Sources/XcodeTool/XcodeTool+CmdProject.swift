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

    private class Parameters : Patch {
      
      public enum ParamCodingKeys : String, CodingKey {
        case version
        case path
        case git
        case submodule
        case createdBy
        case createdAt
        case copyRightYear
        case copyRightName
        case verbose
      }

      public var version: String = "1.0.4"
      public var path: String!
      public var git: Bool?
      public var submodule: Bool?
      public var createdBy: String?
      public var createdAt: String?
      public var copyRightYear: String?
      public var copyRightName: String?
      public var verbose: Bool?
      
    public override init() {
        super.init()
        self.path = "."
        self.git = nil
        self.submodule = nil
        self.createdBy = nil
        self.createdAt = nil
        self.copyRightYear = nil
        self.copyRightName = nil
        self.verbose = false
      }
      
      // MARK: -> Public protocol Encodable
      
      public override func encode(to pEncoder: Encoder) throws {
        try super.encode(to: pEncoder)
        
        var lContainer = pEncoder.container(keyedBy: ParamCodingKeys.self)
        
        try lContainer.encode(version, forKey: .version)
        try lContainer.encode(path, forKey: .path)
        try lContainer.encode(git, forKey: .git)
        try lContainer.encode(submodule, forKey: .submodule)
        try lContainer.encode(createdBy, forKey: .createdBy)
        try lContainer.encode(createdAt, forKey: .createdAt)
        try lContainer.encode(copyRightYear, forKey: .copyRightYear)
        try lContainer.encode(copyRightName, forKey: .copyRightName)
        try lContainer.encode(verbose, forKey: .verbose)
      }
      
      // MARK: -> Public protocol Decodable
      
      public required init(from pDecoder: Decoder) throws {
        try super.init(from: pDecoder)
        
        if let lContainer = try? pDecoder.container(keyedBy: ParamCodingKeys.self) {
          var lInvalidFields:[ParamCodingKeys] = []
          
          // Required
          if let lVersion = try? lContainer.decode(String.self, forKey: .version) {
            version = lVersion
          } else {
            lInvalidFields.append(ParamCodingKeys.version)
          }

          // Required
          if let lPath = try? lContainer.decode(String.self, forKey: .path) {
            path = lPath
          } else {
            lInvalidFields.append(ParamCodingKeys.path)
          }

          // Optional
          if let lGit = try? lContainer.decode(Bool.self, forKey: .git) {
            git = lGit
          }
          
          // Optional
          if let lSubmodule = try? lContainer.decode(Bool.self, forKey: .submodule) {
            submodule = lSubmodule
          }
          
          // Optional
          if let lCreatedBy = try? lContainer.decode(String.self, forKey: .createdBy) {
            createdBy = lCreatedBy
          }
          
          // Optional
          if let lCreatedAt = try? lContainer.decode(String.self, forKey: .createdAt) {
            createdAt = lCreatedAt
          }
          
          // Optional
          if let lCopyRightYear = try? lContainer.decode(String.self, forKey: .copyRightYear) {
            copyRightYear = lCopyRightYear
          }
          
          // Optional
          if let lCopyRightName = try? lContainer.decode(String.self, forKey: .copyRightName) {
            copyRightName = lCopyRightName
          }
          
          // Optional
          if let lVerbose = try? lContainer.decode(Bool.self, forKey: .verbose) {
            verbose = lVerbose
          }
          
          if lInvalidFields.isEmpty == false {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath:lInvalidFields, debugDescription: "invalid fields"))
          }
        } else {
          throw DecodingError.dataCorrupted(DecodingError.Context(codingPath:[], debugDescription: "Invalid data"))
        }
      }
      
    }
    
    public class func rename(_ pVars:[String:String]) {
      display(type: .action, format: "Rename project")
      
      defer {
        display(type: .done)
      }

      var lParams = Parameters()
      
      if let lFile = pVars["file"] {
        if pVars.keys.contains("generate") {
          lParams.createdBy = "John Doe"
          lParams.createdAt = "DD/MM/YYYY"
          lParams.copyRightYear = "YYYY"
          lParams.copyRightName = "Company"
          lParams.git = false
          lParams.submodule = false
          lParams.list = Patch.Constant.list
          lParams.remove = Patch.Constant.remove
          lParams.ignore = Patch.Constant.ignore + [fullname(path:lFile)]
          lParams.protect = Patch.Constant.protect
          lParams.alias = ["NEW":"new"]
          lParams.items = [
            Patch.Item(original: "original", new: "new"),
            Patch.Item(enable: false, files: [Patch.Item.File(name: "SpecificFile1.swift")], original: "original", new: "new"),
            Patch.Item(enable: false, files: [Patch.Item.File(name: "SpecificFile2.swift", continue: false, lines:[5,10,15,20])], original: "original", new: "$(NEW)")
          ]
          
          display(type:writeJson(file: lFile, object: lParams) ? .yes : .no, format: "generate json %@", lFile.fg.c256(104))
          
          return
        } else {
          if let lObj = readJson(codable: Parameters.self, file: lFile) {
            lParams = lObj
            
            lParams.list.set(ifNil: Patch.Constant.list)
            lParams.remove.set(ifNil: Patch.Constant.remove)
            lParams.ignore.set(ifNil: Patch.Constant.ignore)
            lParams.protect.set(ifNil: Patch.Constant.protect)
            
            Display.verbose = lParams.verbose.unwrappedOr(default: false)
          } else {
            display(type: .no, format: "invalid json %@", lFile.fg.c256(104))
            return
          }
        }
      } else {
        Display.verbose = pVars.keys.contains("verbose")
        
        guard let lNew = pVars["new"], lNew.isEmpty == false else {
          display(type: .no, format: "parameter <new> is missing")
          return
        }

        let lPath = pVars["path"].unwrappedOr(default: ".")

        if lParams.add(original: pVars["original"].unwrappedOr(default: name(path: lPath)), new: lNew) {
          display(type: .no, format: "parameter <original> and <new> must be different")
          return
        }

        lParams.path = lPath
        lParams.git = pVars.keys.contains("git")
        lParams.submodule = pVars.keys.contains("submodule")
        lParams.createdBy = pVars["createdBy"]
        lParams.createdAt = pVars["createdAt"]
        lParams.copyRightYear = pVars["copyRightYear"]
        lParams.copyRightName = pVars["copyRightName"]

        lParams.list = pVars["list"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.list)
        lParams.remove = pVars["remove"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.remove)
        lParams.ignore = pVars["ignore"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.ignore)
        lParams.protect = pVars["protect"].unwrapped({$0.components(separatedBy: ",")}, default: Patch.Constant.protect)
      }
      
      if let lRoot = lParams.root {
        if let lGit = lParams.git, lGit == true {
          if Git.set(path: lParams.path, project: lRoot.new) != 0 {
            display(type: .no, format: "git: unable to change url")
            return
          }
        }
  
        if let lSubmodule = lParams.submodule, lSubmodule == true {
          if Git.submodule(path: lParams.path, source: lRoot.original, replace: lRoot.new) == false {
            display(type: .no, format: "git: unable to change submodules")
            return
          }
        }
      }

      lParams.apply(path: lParams.path) {
        pAction in
        
        switch pAction {
        case .rename(let lSource, let lTarget, let lDone):
          display(type: lDone ? .yes : .no, verbose: true, format: "renamed %@ %@ %@",lSource.fg.c256(104),"to".cli.text,lTarget.fg.c256(104))
        case .remove(let lSource, let lDone):
          display(type: lDone ? .yes : .no, verbose: true, format: "removed %@",lSource.fg.c256(104))
        case .patch(let lOriginal, let lNew, let lSource):
          display(type: .yes, verbose: true, format: "patched %@%@ %@ %@ %@",lSource.fg.c256(104), ":".cli.text, lOriginal.fg.c256(72),"to".cli.text,lNew.fg.c256(72))
        case .done(let lOriginal, let lNew, let lDone):
          display(type: lDone ? .yes : .no, format: "patched %@ %@ %@",lOriginal.fg.c256(72),"to".cli.text,lNew.fg.c256(72))
        }
      }
      
      if lParams.createdBy != nil || lParams.createdAt != nil || lParams.copyRightYear != nil || lParams.copyRightName != nil {
        if header(path: lParams.path, createdBy: lParams.createdBy, createdAt: lParams.createdAt, copyRightYear: lParams.copyRightYear, copyRightName: lParams.copyRightName) {
          display(type: .yes, format: "header processed")
        } else {
          display(type: .no, format: "header processing failed")
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
