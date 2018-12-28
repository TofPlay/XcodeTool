//
//  XcodeTool+Template.swift
//  XcodeTool
//
//  Created by Christophe Braud on 04/02/2018.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//
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
  public class Source : Codable {
    public var uuid:String!
    public var name:String!
    public var source:String!
    public var templates:String!
    public var description:String!
    public var branch:String? = nil
    public var tag:String? = nil
    public var author:String? = nil
  }
  
  public class Template : Codable {
    public var name:String!
    public var url:String!
    public var description:String!
    public var branch:String? = nil
    public var tag:String? = nil
    public var subfolder:String? = nil
    public var author:String? = nil

    // since version 1.0.4
    public var patch:String? = nil

    // previous version 1.0.4
    public var original:String? = nil
    public var protect:[String]? = nil
  }
  
  // MARK: -> Public type alias
  
  // MARK: -> Public static properties
  
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
  
  // MARK: -> Public properties
  
  // MARK: -> Public class methods
  
  // MARK: --> Sources methods
  
  public class func source(file pFile:String) -> Source? {
    let lRet:Source? = readJson(codable: Source.self, file: pFile)
    return lRet
  }
  
  public class func source(url pUrl:String, save pSave:Bool=false) -> Source? {
    var lRet:Source? = nil
    var lUrl = pUrl
    
    if isFile(pUrl) {
      lUrl = "file://" + pUrl
    }
    
    if let lSource = readJson(codable: Source.self, url: lUrl) {
      lRet = lSource
      if pSave == true, let lName = lRet?.name, let lUuid = lRet?.uuid, let lUrl = lRet?.templates {
        let lPathSource = pathSources + "\(lName).json"
        let lPathTemplates = pathTemplates + "\(lUuid)/"
        
        if writeJson(file: lPathSource, object: lSource) == false {
          lRet = nil
        } else {
          if isDir(lPathTemplates) {
            if Git.pull(path: lPathTemplates) != 0 {
              lRet = nil
            }
          } else {
            if Git.clone(url: lUrl, target: lPathTemplates, display: false) != 0 {
              lRet = nil
            }
          }

          if lRet != nil && (lSource.branch != nil || lSource.tag != nil) {
            if Git.checkout(path: lPathTemplates, branch: lSource.branch, tag: lSource.tag) == false {
              lRet = nil
            }
          }
        }
      }
    }
    
    return lRet
  }
  
  public class func source(name pName:String) -> Source? {
    let lPathSource = pathSources + "\(pName).json"
    return source(file: lPathSource)
  }
  
  public class func template(file pFile:String) -> Template? {
    let lRet:Template? = readJson(codable: Template.self, file: pFile)
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
  
  // MARK: --> Template methods
  
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

