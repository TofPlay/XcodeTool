//
//  XcodeTool+CmdSimulator.swift
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
  
  public class CmdSimulator {
    
    // MARK: -
    // MARK: Public access
    // MARK: -
    
    // MARK: -> Public enums
    
    // MARK: -> Public structs
    
    // MARK: -> Public class
    
    public class List {
        
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
        
        public class func runtimes(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "List runtimes")
            
            defer {
                display(type: .done)
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan runtimes...")
            
            guard let lRuntimes = simRuntimes() else {
                display(type: .no, format: "runtimes not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lRuntimes.count) runtimes")
            
            display(type: .done)
            
            display(type: .action, format: "Runtimes")
            
            for lRuntime in lRuntimes {
                display(type: .msg, format: "\(lRuntime.name)")
            }
            
            display(type: .done)
        }
        
        public class func devices(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "List devices")
            
            defer {
                display(type: .done)
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan runtimes...")
            
            guard let lDevices = simDeviceTypes() else {
                display(type: .no, format: "devices not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lDevices.count) devices")
            
            display(type: .done)
            
            display(type: .action, format: "Devices")
            
            for lDevice in lDevices {
                display(type: .msg, format: "\(lDevice.name)")
            }
            
            display(type: .done)
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
    
    public class Register {
        
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
        
        public class func runtimes(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "Register runtimes")
            
            defer {
                display(type: .done)
            }
            
            guard let lListOfRuntimes = pVars["list"]?.components(separatedBy: ",") else {
                display(type: .no, format: "parameter <list> invalid or missing")
                return
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan devices...")
            
            guard let lDevices = simDeviceTypes() else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lDevices.count) devices")
            
            display(type: .compute, format: "scan runtimes...")
            
            guard let lRuntimes = simRuntimes() else {
                display(type: .no, format: "runtimes not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lRuntimes.count) runtimes")
            
            display(type: .done)
            
            display(type: .action, format: "Add")
            
            let lRegisterRuntimes = lRuntimes.filter({
                pRuntime in
                
                var lRet = false
                
                if lListOfRuntimes.filter({pRuntime.name.contains($0)}).count > 0 {
                    lRet = true
                }
                
                return lRet
            })
            
            guard lRegisterRuntimes.count > 0 else {
                display(type: .no, format: "invalid list of runtimes")
                display(type: .done)
                return
            }
            
            let lShell = Shell()
            
            for lRegisterRuntime in lRegisterRuntimes {
                for lDevice in lDevices {
                    display(type: .compute, format: "processing...")
                    let lRet = lShell.run("xcrun simctl create '\(lRegisterRuntime.name) - \(lDevice.name)' \(lDevice.id) \(lRegisterRuntime.id)").wait()
                    
                    if lRet == 0 {
                        display(type: .yes, format: "create simulator: \(lRegisterRuntime.name) - \(lDevice.name)")
                    }
                }
            }
            
            display(type: .done)
        }
        
        public class func devices(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "Register devices")
            
            defer {
                display(type: .done)
            }
            
            guard let lListOfDevices = pVars["list"]?.components(separatedBy: ",") else {
                display(type: .no, format: "parameter <list> invalid or missing")
                return
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan devices...")
            
            guard let lDevices = simDeviceTypes() else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lDevices.count) devices")
            
            display(type: .compute, format: "scan runtimes...")
            
            guard let lRuntimes = simRuntimes() else {
                display(type: .no, format: "runtimes not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lRuntimes.count) runtimes")
            
            display(type: .done)
            
            display(type: .action, format: "Add")
            
            let lRegisterDevices = lDevices.filter({lListOfDevices.contains($0.name)})
            
            guard lRegisterDevices.count > 0 else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            let lShell = Shell()
            
            for lRuntime in lRuntimes {
                for lRegisterDevice in lRegisterDevices {
                    display(type: .compute, format: "processing...")
                    let lRet = lShell.run("xcrun simctl create '\(lRuntime.name) - \(lRegisterDevice.name)' \(lRegisterDevice.id) \(lRuntime.id)").wait()
                    
                    if lRet == 0 {
                        display(type: .yes, format: "create simulator: \(lRuntime.name) - \(lRegisterDevice.name)")
                    }
                }
            }
            
            display(type: .done)
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
    
    public class Unregister {
        
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
        
        public class func runtimes(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "Unregister runtimes")
            
            defer {
                display(type: .done)
            }
            
            guard let lListOfRuntimes = pVars["list"]?.components(separatedBy: ",") else {
                display(type: .no, format: "parameter <list> invalid or missing")
                return
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan devices...")
            
            guard let lDevices = simDevices() else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lDevices.count) devices")
            
            display(type: .done)
            
            display(type: .action, format: "Unregister")
            
            let lUnregisterDevices = lDevices.filter({
                pDevice in
                
                var lRet = false
                
                if lListOfRuntimes.filter({pDevice.name.contains($0)}).count > 0 {
                    lRet = true
                }
                
                return lRet
            })
            
            guard lUnregisterDevices.count > 0 else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            let lShell = Shell()
            
            for lUnregisterDevice in lUnregisterDevices {
                display(type: .compute, format: "\(lUnregisterDevice.name)...")
                let lRet = lShell.run("xcrun simctl delete \(lUnregisterDevice.id)").wait()
                
                if lRet == 0 {
                    display(type: .yes, format: "\(lUnregisterDevice.name)")
                } else {
                    display(type: .no, format: "\(lUnregisterDevice.name)")
                }
            }
            
            display(type: .done)
        }
        
        public class func devices(_ pVars:[String:String]) {
            Display.verbose = pVars.keys.contains("verbose")
            
            display(type: .action, format: "Unregister devices")
            
            defer {
                display(type: .done)
            }
            
            guard let lListOfDevices = pVars["list"]?.components(separatedBy: ",") else {
                display(type: .no, format: "parameter <list> invalid or missing")
                return
            }
            
            display(type: .action, format: "Xcode")
            
            let lXcodeVersion = xcodeVersion()
            
            guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
                display(type: .no, format: "require Xcode 9.1 or greater")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found Xcode \(lXcodeVersion)")
            
            display(type: .done)
            
            display(type: .action, format: "Scanning")
            
            display(type: .compute, format: "scan devices...")
            
            guard let lDevices = simDevices() else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            display(type: .yes, format: "found \(lDevices.count) devices")
            
            display(type: .done)
            
            display(type: .action, format: "Unregister")
            
            let lUnregisterDevices = lDevices.filter({
                pDevice in
                
                var lRet = false
                
                if lListOfDevices.filter({pDevice.name.contains($0)}).count > 0 {
                    lRet = true
                }
                
                return lRet
            })
            
            guard lUnregisterDevices.count > 0 else {
                display(type: .no, format: "device not found")
                display(type: .done)
                return
            }
            
            let lShell = Shell()
            
            for lUnregisterDevice in lUnregisterDevices {
                display(type: .compute, format: "\(lUnregisterDevice.name)...")
                let lRet = lShell.run("xcrun simctl delete \(lUnregisterDevice.id)").wait()
                
                if lRet == 0 {
                    display(type: .yes, format: "\(lUnregisterDevice.name)")
                } else {
                    display(type: .no, format: "\(lUnregisterDevice.name)")
                }
            }
            
            display(type: .done)
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
    
    public class func regenerate(_ pVars:[String:String]) {
        Display.verbose = pVars.keys.contains("verbose")
        
        display(type: .action, format: "Regenerate all simulators")
        
        defer {
            display(type: .done)
        }
        
        display(type: .action, format: "Xcode")
        
        let lXcodeVersion = xcodeVersion()
        
        guard lXcodeVersion.version(equalToOrGreaterThan: "9.1") else {
            display(type: .no, format: "require Xcode 9.1 or greater")
            display(type: .done)
            return
        }
        
        display(type: .yes, format: "found Xcode \(lXcodeVersion)")
        
        display(type: .done)
        
        display(type: .action, format: "Scanning")
        
        display(type: .compute, format: "scan devices type...")
        
        guard let lDeviceTypes = simDeviceTypes() else {
            display(type: .no, format: "devices types not found")
            display(type: .done)
            return
        }
        
        display(type: .yes, format: "found \(lDeviceTypes.count) devices")
        
        display(type: .compute, format: "scan runtimes...")
        
        guard let lRuntimes = simRuntimes() else {
            display(type: .no, format: "runtimes not found")
            display(type: .done)
            return
        }
        
        display(type: .yes, format: "found \(lRuntimes.count) runtimes")
        
        let lDevices = simDevices().unwrappedOr(default: [])
        
        display(type: .compute, format: "scan existing simulators...")
        
        // Remove existing simulators
        let lShell = Shell()
        
        if lDevices.count == 0 {
            display(type: .yes, format: "no simulators")
            display(type: .done)
        } else {
            display(type: .yes, format: "found \(lDevices.count) simulators")
            display(type: .done)
            
            display(type: .action, format: "Remove previous simulators")
            for lDevice in lDevices {
                let lRet = lShell.run("xcrun simctl delete \(lDevice.id)").wait()
                
                if lRet == 0 {
                    display(type: .yes, format: "remove simulator: \(lDevice.name)")
                }
            }
            display(type: .done)
        }
        
        display(type: .action, format: "Create new simulators")
        for lRuntime in lRuntimes {
            for lType in lDeviceTypes {
                display(type: .compute, format: "processing...")
                let lRet = lShell.run("xcrun simctl create '\(lRuntime.name) - \(lType.name)' \(lType.id) \(lRuntime.id)").wait()
                
                if lRet == 0 {
                    display(type: .yes, format: "create simulator: \(lRuntime.name) - \(lType.name)")
                }
            }
        }
        display(type: .done)
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

