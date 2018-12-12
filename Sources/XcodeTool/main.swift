//
//  main.swift
//  XcodeTool
//
//  Created by Christophe Braud on 11/06/2017.
//  Base on Tof Templates (https://bit.ly/2OWAgmb)
//  Copyright © 2017 Christophe Braud. All rights reserved.
//

import Foundation
import ScriptKit

public class XcodeTool : ScriptKit {
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
  
  // MARK: -
  // MARK: Main
  // MARK: -
  
  public class func main() {
    program(version: "1.0.3", owner: "Christophe Braud", year: "2018", info: "Collection of tools for Xcode projects")
    
      cmd("project", title: "Actions on projects")
        begin()
          cmd("rename", title: "Rename classes, projects, git url, git submodules,...", handler: CmdProject.rename)
            option(short: "n", long: "new", variable: "new", value: "value", optional: false, title: "New value")
            option(short: "o", long: "original", variable: "original", value: "value", optional: true, title: "Original value. By default takes last folder of the path.")
            option(short: "p", long: "path", variable: "path", default: ".", value: "path", optional: true, title: "Path of the original project. By default \".\"")
            option(short: "g", long: "git", variable: "git", optional: true, title: "Rename projet on the git repository. By default not used.")
            option(short: "s", long: "submodule", variable: "submodule", optional: true, title: "Rename projet on .gitmodules. By default not used.")
            option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            option(long: "list", variable: "list", value: "list of files or extensions", optional: true, title: "List of supported extensions. By default Podfile, swift,h,m,storyboard,xib,md,plist,json,strings,png,pbxproj,xcworkspacedata,xcscheme,appiconset")
            option(long: "remove", variable: "remove", value: "list of files or folders", optional: true, title: "List of files or directories to delete. By default xcuserdata,podspec")
            option(long: "ignore", variable: "ignore", value: "list of files or folders", optional: true, title: "List of files or directories must be ignored. By default Pods, Carthage")
            option(long: "protect", variable: "protect", value: "list of sequences", optional: true, title: "List of sequences must be protected. By default none")
            option(long: "createdBy", variable: "createdBy", value: "owner", optional: true, title: "Specify the owner")
            option(long: "createdAt", variable: "createdAt", value: "DD/MM/YYYY", optional: true, title: "Specify the creation date")
            option(long: "copyRightYear", variable: "copyRightYear", value: "YYYY", optional: true, title: "Specify copyright year")
            option(long: "copyRightName", variable: "copyRightName", value: "name", optional: true, title: "Specify copyright name")
        end()

      cmd("template", title: "Manage predefine templates that you can used to create your own project", handler: CmdTemplate.root)
        option(short: "n", long: "name", variable: "name", value: "name", optional: false, title: "Name of the template")
        option(short: "t", long: "target", variable: "target", value: "directory", optional: false, title: "Target directory where the project is cloned. The last folder is also the name of the project.")
        option(short: "x", long: "xcode", variable: "xcode", optional: true, title: "Generate Xcode project for template base on SwiftPM")
        option(short: "b", long: "branch", variable: "branch", optional: true, title: "Use a specific branch of the template")
        option(short: "a", long: "tag", variable: "tag", optional: true, title: "Use a specific tag of the template")
        option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
        option(long: "list", variable: "list", value: "list of files or extensions", optional: true, title: "List of supported extensions. By default Podfile, swift,h,m,storyboard,xib,md,plist,json,strings,png,pbxproj,xcworkspacedata,xcscheme,appiconset")
        option(long: "remove", variable: "remove", value: "list of files or folders", optional: true, title: "List of files or directories to delete. By default xcuserdata,podspec")
        option(long: "ignore", variable: "ignore", value: "list of files or folders", optional: true, title: "List of files or directories must be ignored. By default Pods, Carthage")
        option(long: "protect", variable: "protect", value: "list of sequences", optional: true, title: "List of sequences must be protected. By default none")
        option(long: "createdBy", variable: "createdBy", value: "owner", optional: true, title: "Specify the owner")
        option(long: "createdAt", variable: "createdAt", value: "DD/MM/YYYY", optional: true, title: "Specify the creation date")
        option(long: "copyRightYear", variable: "copyRightYear", value: "YYYY", optional: true, title: "Specify copyright year")
        option(long: "copyRightName", variable: "copyRightName", value: "name", optional: true, title: "Specify copyright name")
        begin()
          cmd("source", title: "Manage sources of templates")
          begin()
            cmd("gen", title: "generate a json file for a new source", handler: CmdTemplate.Source.gen)
              option(short: "n", long: "name", variable: "name", value: "name", optional: false, title: "Source's name")
              option(short: "t", long: "templates", variable: "templates", value: "url", optional: false, title: "Repository where we have a list of json. One json by template.")
              option(short: "s", long: "source", variable: "url", value: "url", optional: true, title: "Source's url")
              option(short: "i", long: "version", variable: "version", value: "version", optional: true, title: "Source's version")
              option(short: "d", long: "description", variable: "description", value: "description", optional: true, title: "Source's description")
              option(short: "a", long: "author", variable: "author", value: "author", optional: true, title: "Source's author")
              option(short: "f", long: "file", variable: "file", value: "file", optional: true, title: "Store the json in this file. By default use <current directory + source's name + '.json'>")
              option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            cmd("add", variable: "url", title: "Add a source", handler: CmdTemplate.Source.add)
              option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            cmd("del", variable: "name", title: "Remove a source", handler: CmdTemplate.Source.del)
              option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            cmd("refresh", variable: "name", title: "Refresh templates of a source", handler: CmdTemplate.Source.refresh)
              option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            cmd("default", variable: "name", title: "Change defaults sources. If '--add' or '--del' is not specify '--add' is used by default.", handler: CmdTemplate.Source.default)
              option(short: "a", long: "add", variable: "add", optional: true, title: "Add another default source")
              option(short: "d", long: "del", variable: "del", optional: true, title: "Remove another default source")
              option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
            cmd("ls", title: "List of sources installed", handler: CmdTemplate.Source.ls)
          end()
          cmd("gen", title: "Generate a json file for a new template", handler: CmdTemplate.gen)
            option(short: "n", long: "name", variable: "name", value: "name", optional: false, title: "Template's name")
            option(short: "u", long: "url", variable: "url", value: "url", optional: false, title: "Template's url. Must terminate by '.xtemplate' or '.xtemplate.git'")
            option(short: "d", long: "description", variable: "description", value: "description", optional: true, title: "Template's description")
            option(short: "o", long: "original", variable: "original", value: "name", optional: true, title: "Original name of the template project")
            option(short: "b", long: "branch", variable: "branch", value: "name", optional: true, title: "Template's branch")
            option(short: "t", long: "tag", variable: "tag", value: "name", optional: true, title: "Template's tag")
            option(short: "p", long: "protect", variable: "protect", value: "string", optional: true, title: "Sequence to protect")
            option(short: "i", long: "version", variable: "version", value: "version", optional: true, title: "Template's version")
            option(short: "a", long: "author", variable: "author", value: "author", optional: true, title: "Template's author")
            option(short: "f", long: "file", variable: "file", value: "json file", optional: true, title: "Store the json in this file. By default use <current directory + template's name + '.json'>")
            option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")
          cmd("ls", title: "List templates available", handler: CmdTemplate.ls)
            option(short: "s", long: "source", variable: "source", value: "name", optional: true, title: "Specificy a source. Default value 'XcodeTool'")
        end()

      cmd("markdown", title: "Generate markdown files for documentation found in swift files", handler: CmdMarkdown.root)
        option(short: "f", long: "folder", variable: "folder", value: "folder", optional: false, title: "scan swift files on the folder and sub-folders to generate markdown files")
        option(short: "d", long: "docs", variable: "docs", value: "folder", optional: true, title: "folder where we store the documentation. By default current directory + '/Docs/'")
        option(short: "o", long: "one", variable: "one", value: "file", optional: true, title: "put all markdown doc in one file")
        option(short: "m", long: "main", variable: "main", value: "file", optional: true, title: "generate a main markdown file where we list all others markdown files. By default not used.", help: "If you generate multiple markdown files you specify a file to linked all others files.")
        option(short: "v", long: "verbose", variable: "verbose", optional: true, title: "Display more informations")

     cmd("simulator", title: "Manipulate Xcode simulators")
        begin()
            cmd("list", title: "List runtimes and devices")
              begin()
                cmd("runtimes", title: "List runtimes", handler: CmdSimulator.List.runtimes)
                cmd("devices", title: "List devices", handler: CmdSimulator.List.devices)
              end()
            cmd("register", title: "Register devices or runtimes")
              begin()
                cmd("runtimes", title: "Register runtimes", handler: CmdSimulator.Register.runtimes)
                  option(short: "l", long: "list", variable: "list", value: "list of runtimes", optional: false, title: "List of runtimes to register. Ex: --list=\"iOS 8.4,iOS 9.3,iOS 10.3\"")
                cmd("devices", title: "Register devices", handler: CmdSimulator.Register.devices)
                  option(short: "l", long: "list", variable: "list", value: "list of devices", optional: false, title: "List of devices to register. Ex: --list=\"iPhone 4s,iPhone 5s,iPhone 6\"")
              end()
            cmd("unregister", title: "Unregister devices or runtimes")
              begin()
                cmd("runtimes", title: "Unregister runtimes", handler: CmdSimulator.Unregister.runtimes)
                  option(short: "l", long: "list", variable: "list", value: "list of runtimes", optional: false, title: "List of runtimes to unregister. Ex: --list=\"iOS 8.4,iOS 9.3,iOS 10.3\"")
                cmd("devices", title: "Unregister devices", handler: CmdSimulator.Unregister.devices)
                  option(short: "l", long: "list", variable: "list", value: "list of devices", optional: false, title: "List of devices to unregister. Ex: --list=\"iPhone 4s,iPhone 5s,iPhone 6\"")
              end()
            cmd("regenerate", title: "Regenerate all Xcode simulators", handler: CmdSimulator.regenerate)
        end()

    cmd(path:"markdown", help: """
    Support format generated by Xcode when you click on ⌥ + ⌘ + /

    Example:
    /// Your application can define a collection of commands and sub-commands
    ///
    /// Each command have his own keyword, a text that describ the commande and instructions
    ///
    /// - Parameters:
    ///   - pName: Key word for this command
    ///   - pVariable: Store the next value after the command on this variable
    ///   - pTitle: A short descrition of this command
    ///   - pHelp: A long descrition of this command
    ///   - pCmdHandler: Instrutions of this command
    /// - Returns: ScriptKit class object for chaining settings
    public class func cmd(_ pName:String, variable pVariable:String?=nil, title pTitle:String="", help pHelp:String="", handler pCmdHandler:CmdHandler? = nil) {
    ...
    """)
    
    if initialize() == false {
      display(type: .error, format: "Unable to initialized XcodeTool")
    } else {
      run(arguments: CommandLine.arguments)
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

XcodeTool.main()
