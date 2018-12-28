//
//  XcodeTool+Patch.swift
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
public extension XcodeTool {

  // MARK: -
  // MARK: XcodeTool.Patch
  // MARK: -
  public class Patch : Codable {
    // MARK: -
    // MARK: Public access
    // MARK: -
    
    public enum CodingKeys : String, CodingKey {
      case list
      case remove
      case ignore
      case protect
      case alias
      case items
    }
    
    // MARK: -> Public enums
    
    public enum Action {
      case rename(String, String, Bool)
      case remove(String, Bool)
      case patch(String, String, String)
      case done(String, String, Bool)
    }
    
    // MARK: -> Public structs
    
    // MARK: -> Public class
    
    public class Constant {
      public static let list = "Podfile,swift,h,m,storyboard,xib,md,plist,json,strings,png,pbxproj,xcworkspacedata,xcscheme,appiconset".components(separatedBy: ",")
      public static let remove = "xcuserdata,podspec".components(separatedBy: ",")
      public static let ignore = "Pods,Carthage".components(separatedBy: ",") + [".git"]
      public static let protect:[String] = []
    }
    
    public class Item : Codable {

      public class File : Codable {
        public var name:String!
        public var `continue`:Bool?
        public var lines:[Int]? = nil
        
        public init(name pName:String, continue pContinue:Bool = true, lines pLines:[Int]? = nil) {
          self.name = pName
          self.continue = pContinue
          self.lines = pLines
        }
      }
      public var enable:Bool = true
      public var files:[File]? = nil
      public var original:String!
      public var new:String!
      
      public init(enable pEnable: Bool = true, files pFiles:[Item.File]? = nil, original pOriginal:String, new pNew:String) {
        self.enable = pEnable
        self.files = pFiles
        self.original = pOriginal
        self.new = pNew
      }
    }

    // MARK: -> Public type alias
    
    public typealias Handler = (Action) -> Void
    
    // MARK: -> Public static properties
    
    // MARK: -> Public properties
    
    public var list:[String]?
    public var remove:[String]?
    public var ignore:[String]?
    public var protect:[String]?
    public var alias:[String:String]?
    public var items:[Item]
    
    public var root:Item? {
      return items.first(where: ({$0.files == nil && $0.enable == true}))
    }
    
    // MARK: -> Public class methods
    
    // MARK: -> Public init methods
    
    public init() {
      self.list = nil
      self.remove = nil
      self.ignore = nil
      self.protect = nil
      self.alias = nil
      self.items = []
    }
    
    public convenience init(original pOriginal:String, new pNew:String) {
      self.init()
      self.add(original: pOriginal, new: pNew)
    }
    
    // MARK: -> Public operators
    
    // MARK: -> Public methods
    
    @discardableResult
    public func add(files pFiles:[Item.File]? = nil, original pOriginal:String, new pNew:String) -> Bool {
      var lRet = false
      
      if pOriginal != pNew && pOriginal.isEmpty == false && pNew.isEmpty {
        let lItem =  Item(files: pFiles, original: pOriginal, new: pNew)
        
        if let lIndex = items.index(where: {$0.original == pOriginal}) {
          items[lIndex] = lItem
        } else {
          items.append(lItem)
        }

        lRet = true
      }
      
      return lRet
    }
    
    public func del(original pOriginal:String) {
      if let lIndex = items.index(where: {$0.original == pOriginal}) {
        items.remove(at: lIndex)
      }
    }
    
    public func contain(original pOriginal:String, new pNew:String? = nil) -> Bool {
      let lItem = items.first(where: {$0.original == pOriginal})
      var lRet = lItem != nil

      if let lNew = pNew, lRet {
        lRet = lItem?.new == lNew
      }
      
      return lRet
    }
    
    public func apply(string pString:String? = nil, file pFile:String? = nil) -> (count:Int, content:String)? {
      var lRet = (count:0, content:pString.unwrappedOr(default: ""))
      
      var lProtects:[String:String] = [:]
      var lItems:[Item] = []
      var lContent:String? = nil

      if let lString = pString, pFile == nil {
        lContent = lString
        lItems = items.filter({$0.files == nil && $0.enable == true})
      } else if let lFile = pFile {
        lContent = pString.unwrappedOr(default: content(file: lFile).unwrappedOr(default: ""))
        lItems = items.filter({$0.files != nil && $0.enable == true}) + items.filter({$0.files == nil && $0.enable == true})
      }

      if let lString = lContent, let lProtect = protect, lProtect.count > 0 {
        let lUuids = lProtect.map({ _ in UUID().uuidString })
        lProtects = Dictionary(uniqueKeysWithValues: zip(lUuids, lProtect))
        
        for (lUuid, lValue) in lProtects {
          lContent = lString.replace(string: lValue, sub: lUuid)
        }
      }
      
      guard var lLines = lContent?.components(separatedBy: "\n") else {
        return lRet
      }
      
      var lCount = 0
      let lFullName = fullname(path: pFile.unwrappedOr(default: ""))
      
      for lItem in lItems {
        let lItemOriginal = alias(lItem.original)
        let lItemNew = alias(lItem.new)
        var lName = ""
        var lItemFile: Patch.Item.File? = nil
        var lFileLines:[Int] = []
        var lItemCount = 0
        
        if let lFile = lItem.files?.first(where: {$0.name == lFullName}) {
          lItemFile = lFile
          lName = lFile.name
          
          if let lLines = lFile.lines {
            lFileLines = lLines
          }
        }
        
        if lItem.files == nil || lName.isEmpty == false {
          for lI in 0..<lLines.count {
            if lFileLines.isEmpty || lFileLines.contains(lI+1) {
              let lLine = lLines[lI]
              
              let lCpt = lLine.components(separatedBy: lItemOriginal).count
              
              if lCpt > 1 {
                lCount += lCpt - 1
                lItemCount += lCpt - 1
                lLines[lI] = lLine.replace(string: lItemOriginal, sub: lItemNew)
              }
            }
          }
        }
        
        if let lPath = pFile, let lFile = lItemFile, lItemCount > 0 {
          self.actions?.append(.patch(lItemOriginal, lItemNew, lPath))
          if lFile.continue == false {break}
        }
      }
  
      lContent = lLines.joined(separator: "\n")
      
      if let lString = lContent, lProtects.count > 0 {
        for (lUuid, lValue) in lProtects {
          lContent = lString.replace(string: lUuid, sub: lValue)
        }
      }
      
      if lCount > 0 {
        lRet = (lCount, lContent.unwrappedOr(default: ""))
      }
      
      return lRet
    }
    
    @discardableResult
    public func apply(path pPath:String, handler pHandler:@escaping Handler = {_ in}) -> Bool {
      let lPath = pPath.hasSuffix("/") == false ? "\(pPath)/" : pPath
      let lRet = apply(glob: [lPath], handler: pHandler)
      return lRet
    }
    
    @discardableResult
    public func apply(glob pGlob:[String], handler pHandler:@escaping Handler = {_ in}) -> Bool {
      actions = []
      
      let lRet = exec(glob: pGlob)
      var lDones:[String:Action] = [:]
      
      for lAction in actions.unwrappedOr(default: []) {
        pHandler(lAction)
        
        if case .patch(let lOrignal, let lNew, _) = lAction {
          let lKey = "#\(lOrignal)#\(lNew)"
          if lDones.keys.contains(lKey) == false {
            lDones[lKey] = .done(lOrignal,lNew, true)
          }
        }
      }
      
      for lDone in lDones.values {
        pHandler(lDone)
      }
      
      return lRet
    }
    
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
    
    private var actions:[Action]? = nil
    
    // MARK: -> Private class methods
    
    // MARK: -> Private init methods
    
    // MARK: -> Private operators
    
    // MARK: -> Private methods
    
    private func alias(_ pString:String) -> String {
      var lRet = pString
      
      guard let lAlias = alias else {
        return lRet
      }

      let lFoundKeys = lAlias.keys.filter({pString.contains("$(\($0))")})

      if lFoundKeys.count > 0 {
        lFoundKeys.forEach({lRet = lRet.replace(string: "$(\($0))", sub: lAlias[$0])})
      }
      return lRet
    }
    
    private func isIgnore(_ pFileOrExt:String) -> Bool {
      var lRet = false

      let lFileOrExt = alias(pFileOrExt)

      guard let lIgnore = ignore else {
        return lRet
      }
      
      lRet = lIgnore.contains(ext(path: lFileOrExt)) || lIgnore.contains(fullname(path: lFileOrExt))
      
      return lRet
    }
    
    private func remove(fileOrExt pFileOrExt:String) -> Bool {
      var lRet = false
      
      guard let lRemove = remove else {
        return lRet
      }
      
      let lFileOrExt = alias(pFileOrExt)

      if lRemove.contains(ext(path: lFileOrExt)) || lRemove.contains(fullname(path: lFileOrExt)) {
        if isDir(lFileOrExt) == true {
          lRet = rmdir(path: lFileOrExt)
        } else {
          lRet = rm(path: lFileOrExt)
        }
        self.actions?.append(.remove(lFileOrExt, lRet))
      }
      
      return lRet
    }
    
    private func rename(fileOrExt pFileOrExt:String) -> String? {
      let lFileOrExt = alias(pFileOrExt)
      let lName = fullname(path: lFileOrExt)
      var lRet:String? = lFileOrExt

      if let lResult = self.apply(string: lName), lResult.count > 0 {
        lRet = dir(path: lFileOrExt) + alias(lResult.content)
        
        if mv(at: lFileOrExt, to: lRet!) == false {
          self.actions?.append(.rename(lFileOrExt,lRet!,false))
          lRet = nil
        } else {
          self.actions?.append(.rename(lFileOrExt,lRet!,true))
        }
      }
      
      return lRet
    }
    
    private func content(file pFile:String) -> String? {
      var lRet:String? = nil
      
      guard let lList = list else {
        return lRet
      }
      
      if isFile(pFile) {
        let lContinue = lList.count > 0 ? lList.contains(ext(path: pFile)) || lList.contains(fullname(path: pFile)) : true
        
        if lContinue {
          lRet = readText(file: pFile)
        }
      }
      
      return lRet
    }
    
    public func exec(glob pGlob:[String]) -> Bool {
      guard items.count > 0 else {
        return false
      }
      
      var lRet = true
      
      for lPath in pGlob where lRet == true {
        if let lCurrent = rename(fileOrExt: lPath) {
          if isDir(lCurrent) == true {
            let lGlob = glob(path: lCurrent).filter({isIgnore($0) == false})
            lRet = exec(glob: lGlob)
          } else if remove(fileOrExt: lCurrent) {
            continue
          } else if let lContent = content(file: lCurrent) {
            if let lResult = apply(string: lContent, file: lCurrent), lResult.content != lContent {
              lRet = writeText(file: lCurrent, string: lResult.content)
            }
          }
        } else {
          lRet = false
        }
      }
      
      return lRet
    }
  }
}

