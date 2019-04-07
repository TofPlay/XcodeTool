//
//  XcodeTool+Simulator.swift
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
extension XcodeTool {
  // MARK: -
  // MARK: Public access
  // MARK: -
  
  // MARK: -> Public enums
  
  // MARK: -> Public structs
  
  // MARK: -> Public class
  
  public class DeviceType {
    public var name:String
    public var id: String
    
    init(name pName:String, id pId:String) {
      self.name = pName
      self.id = pId
    }
  }
  
  public class Runtime {
    public var name:String
    public var id: String
    
    init(name pName:String, id pId:String) {
      self.name = pName
      self.id = pId
    }
  }
  
  public class Device {
    public var name:String
    public var id: String
    
    init(name pName:String, id pId:String) {
      self.name = pName
      self.id = pId
    }
  }
  
  // MARK: -> Public type alias
  
  // MARK: -> Public static properties
  
  // MARK: -> Public properties
  
  // MARK: -> Public class methods
  
  public class func xcodeVersion() -> String {
    var lRet = ""
    
    if let lXcodeBuild = whereis("xcodebuild") {
      let lShell = Shell()
      
      lShell.run("\(lXcodeBuild) -version").wait()
      
      for lLine in lShell.stdout {
        let lResult = lLine.extract(regEx: "Xcode ([\\d.]*)")
        
        if lResult.count == 1 {
          lRet = lResult[0].trim()
          break
        }
      }
    }
    
    return lRet
  }
  
  public class func simExist() -> Bool {
    let lRet = whereis("xcrun") != nil
    return lRet
  }
  
  public class func simDeviceTypes() -> [DeviceType]? {
    var lRet:[DeviceType]? = nil
    
    if simExist() {
      let lShell = Shell()
      
      lShell.run("xcrun simctl list devicetypes").wait()
      
      for lLine in lShell.stdout {
        let lResult = lLine.extract(regEx: "(.*) \\((com.apple.CoreSimulator.*)\\)")
        
        if lResult.count == 2 {
          if lRet == nil {
            lRet = []
          }
          
          let lDeviceType = DeviceType(name: lResult[0], id: lResult[1])
          lRet!.append(lDeviceType)
        }
      }
    }
    
    return lRet
  }
  
  public class func simRuntimes() -> [Runtime]? {
    var lRet:[Runtime]? = nil
    
    if simExist() {
      let lShell = Shell()
      
      lShell.run("xcrun simctl list runtimes").wait()
      
      for lLine in lShell.stdout {
        let lResult = lLine.extract(regEx: "([^\\(]*)\\s.* - (.*)")
        
        if lResult.count == 2 {
          if lRet == nil {
            lRet = []
          }
          
          let lRuntime = Runtime(name: lResult[0], id: lResult[1])
          lRet!.append(lRuntime)
        }
      }
    }
    
    return lRet
  }
  
  public class func simDevices() -> [Device]? {
    var lRet:[Device]? = nil
    
    if simExist() {
      let lShell = Shell()
      
      lShell.run("xcrun simctl list devices").wait()
      
      for lLine in lShell.stdout {
        let lResult = lLine.extract(regEx: "\\s*(.*)\\s\\((\\w{8}\\-\\w{4}\\-\\w{4}\\-\\w{4}\\-\\w{12}).*")
        
        if lResult.count == 2 {
          if lRet == nil {
            lRet = []
          }
          
          let lDevice = Device(name: lResult[0], id: lResult[1])
          lRet!.append(lDevice)
        }
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

