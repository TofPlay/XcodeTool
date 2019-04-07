<p align="center">
    <img src="https://user-images.githubusercontent.com/1082222/30913661-4900771c-a391-11e7-9f4c-e2d51ddd451b.jpg" alt="ScriptKit" />
</p>


![macOS](https://img.shields.io/badge/macOS-10.14.4-6193DF.svg)
![Xcode](https://img.shields.io/badge/Xcode-10.2-6193DF.svg)
![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg) 
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) 
![Plaform](https://img.shields.io/badge/Platform-macOS-lightgrey.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 

---

## Table of contents

* [What is XcodeTool?](#what-is-xcodetool)
* [Installation](#installation)
  * [Manually](#manually)
* [Command project](#command-project)
* [Command template](#command-template)
  * [Predefined template](#predefined-templates)
    * [Create a new component cross-platform](#create-a-new-component-cross-platform)
    * [Create a command line tool](#create-a-command-line-tool)
  * [Custom source](#custom-source)
    * [Create you own source](#create-you-own-source)
    * [Use a source as a default source](#use-a-source-as-a-default-source)
    * [List all templates available on default sources](#list-all-templates-available-on-default-sources)
    * [Create you own source]()
* [Command markdown](#command-markdown)
* [Command simulator](#command-simulator)

---

# What is XcodeTool?

XcodeTool is a command-line utility for iOS and MacOS developers. It aims to provide a set of tools to facilitate the development of command line tools, iOS and macOS applications.

# Installation 

## Manually

Open a terminal and excute these commands:
```
$ git clone https://github.com/TofPlay/XcodeTool 
$ cd XcodeTool
$ swift build -c release 
$ cp -v ./.build/x86_64-apple-macosx10.10/release/XcodeTool  /usr/local/bin/XcodeTool
```

When you launch XcodeTool on the terminal you should see this screen

![image](https://user-images.githubusercontent.com/1082222/50453972-d3f53780-0944-11e9-9a34-5ce350bcfa33.png)

# Command self

![image](https://user-images.githubusercontent.com/1082222/50454012-0868f380-0945-11e9-96d1-21ed9c3c02c4.png)


# Command project

![image](https://user-images.githubusercontent.com/1082222/32666510-f0f47b08-c637-11e7-9eaa-5c98bc180ab7.png)
![image](https://user-images.githubusercontent.com/1082222/49854706-5d582600-fdeb-11e8-821c-73bcc33837c9.png)

With this command you can rename a class or a project. Change the git url or rename a git submodule.

# Command template

![image](https://user-images.githubusercontent.com/1082222/50453761-36e5cf00-0943-11e9-9ab1-c2e48beab828.png)

`template` is a command to create projets base on template projects. 
You can use predefined templates provide with XcodeTool. You can also create you own sources and your own templates.


## Predefined templates

### Create a new component cross-platform

This template is base on tutorial: [Swift Cross Platform Framework](https://github.com/TofPlay/SwiftCrossPlatformFramework)

1. Create your component with the template `ComponentCrossPlatform`

![image](https://user-images.githubusercontent.com/1082222/50454145-e1f78800-0945-11e9-839b-d1b83f38efcc.png)

XcodeTool will generate this project for you:

![image](https://user-images.githubusercontent.com/1082222/27770435-13626b06-5f3f-11e7-8eaf-dbd0860369d6.png)

2. Open your first component cross-platform with Xcode

![image](https://user-images.githubusercontent.com/1082222/27770423-d28803ac-5f3e-11e7-9186-b8e1ffa08492.png)

### Create a command line tool

1. To generate your first command line tool project:

![image](https://user-images.githubusercontent.com/1082222/50454207-40246b00-0946-11e9-95ae-301a08a2f83d.png)

XcodeTool will generate this project for you:

![image](https://user-images.githubusercontent.com/1082222/27724973-9288ac46-5d74-11e7-8d8a-b630a7c92187.png)

2. Open your first command line tool with Xcode

![image](https://user-images.githubusercontent.com/1082222/50454266-ac9f6a00-0946-11e9-90b1-979ff2dcc861.png)


## Custom source

### Create you own source

1. Create a git repository for your sources like https://github.com/JohnDoe/MySources

2. Generate the json file for a new source

```
$ XcodeTool template source gen --name=NewSource --url=https://github.com/JohnDoe/MySources/NewSource.json --templates=https://github.com/JohnDoe/NewSourceTemplates --description="All my crazy templates" --author="John Doe"

 ► Source generate json
   ✔︎ json file for the new source saved a /Users/johnDoe/projects/github/MySources/NewSource.json'
 ► done
 ```

3. Commit your `NewSource.json` on https://github.com/JohnDoe/MySources

4. Create a git repository for the templates https://github.com/JohnDoe/NewSourceTemplates

5. Create a json for you new crazy template

```
$ XcodeTool template gen --name=NewTemplate --url=https://github.com/JohnDoe/NewTemplate.xtemplate.git --description="My new crazy template" --original=NewTemplate --tag=1.0.0 --author-"John Doe"

 ► Template generate json
   ✔︎ json file for the new template saved at '/Users/johnDoe/projects/github/NewSourceTemplates/NewTemplate.json'
 ► done
```

6. Generate the json patch file
```
$ XcodeTool template gen patch --file=XcodeTool.json --generate
```

7. Customize your `XcodeTool.json` by adding or removing aliases and adding items

8. Commit `XcodeTool.json` on https://github.com/JohnDoe/NewTemplate.xtemplate.git

9. Commit your `NewTemplate.json` on https://github.com/JohnDoe/NewSourceTemplates

10. Declare your source for XcodeTool

```
$ XcodeTool template source add https://raw.githubusercontent.com/JohnDoe/MySources/master/NewSource.json

 ► Source add
   ✔︎ source "NewSource" added
 ► done
```

### Use a source as a default source

1. List installed sources

```
$ XcodeTool template source ls

Sources available:

  XcodeTool: XcodeTool default templates

  NewSource: All my crazy templates

Default sources: XcodeTool
```

2. Declare `NewSource` as a default source

```
$ XcodeTool template source default NewSource --add

 ► Source default
   ✔︎ source "NewSource" added has a default source
 ► done
```
3. Check default sources

```
$ XcodeTool template source ls

Sources available:

  XcodeTool: XcodeTool default templates

  NewSource: All my crazy templates

Default sources: XcodeTool, NewSource
```

### List all templates available on default sources

```
$ XcodeTool template ls

Templates available:

  ComponentCrossPlatform: Swift Cross-Platform framework from the same sources for macOS, iOS, watchOS and tvOS platforms and use them in a project via Carthage. It will be also ready for SwiftPM.

  ScriptKit: Create a command line tool with ScriptKit
  
  NewTemplate: My new crazy template
```

`ComponentCrossPlatform` and `ScriptKit` come from XcodeTool and `NewTemplate` from your source

# Command markdown

![image](https://user-images.githubusercontent.com/1082222/32667050-d1bfae22-c639-11e7-945e-3a048baf67d7.png)

For example to generate the documentation of [ScriptKit](https://github.com/TofPlay/ScriptKit/tree/master/Docs):

![image](https://user-images.githubusercontent.com/1082222/32667135-1b1724ba-c63a-11e7-9746-4c0aa8ea7fc3.png)

That generate the folder `Docs` in the project

![image](https://user-images.githubusercontent.com/1082222/27764678-4f688afe-5e9f-11e7-8167-4b98a5536923.png)

And on the folder for each swift source we have mardown

![image](https://user-images.githubusercontent.com/1082222/27764685-8f654f2a-5e9f-11e7-946f-1ae41901f3ea.png)

# Command simulator
Some commands are available for the simlator

```
$ XcodeTool simulator 

Manipulate Xcode simulators

Optional:
  --help  current screen

Sub-commands:
  list        List runtimes and devices
  register    Register devices or runtimes
  unregister  Unregister devices or runtimes
  regenerate  Regenerate all Xcode simulators
```

You can list runtimes or devices

```
$ XcodeTool simulator list

List runtimes and devices

Optional:
  --help  current screen

Sub-commands:
  runtimes  List runtimes
  devices   List devices
```
```
$ XcodeTool simulator list runtimes

 ► List runtimes
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 13 runtimes
   ► Runtimes
     ⇢ iOS 8.4
     ⇢ iOS 9.3
     ⇢ iOS 10.3
     ⇢ iOS 11.3
     ⇢ iOS 11.4
     ⇢ iOS 12.0
     ⇢ iOS 12.1
     ⇢ tvOS 10.2
     ⇢ tvOS 11.4
     ⇢ tvOS 12.1
     ⇢ watchOS 3.2
     ⇢ watchOS 4.2
     ⇢ watchOS 5.1
 ► done
```
```
$ XcodeTool simulator list devices

 ► List devices
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 39 devices
   ► Devices
     ⇢ iPhone 4s
     ⇢ iPhone 5
     ⇢ iPhone 5s
     ⇢ iPhone 6
     ⇢ iPhone 6 Plus
     ⇢ iPhone 6s
     ⇢ iPhone 6s Plus
     ⇢ iPhone 7
     ⇢ iPhone 7 Plus
     ⇢ iPhone 8
     ⇢ iPhone 8 Plus
     ⇢ iPhone SE
     ⇢ iPhone X
     ⇢ iPhone Xs
     ⇢ iPhone Xs Max
     ⇢ iPhone Xʀ
     ⇢ iPad 2
     ⇢ iPad Retina
     ⇢ iPad Air
     ⇢ iPad Air 2
     ⇢ iPad (5th generation)
     ⇢ iPad Pro (9.7-inch)
     ⇢ iPad Pro (12.9-inch)
     ⇢ iPad Pro (12.9-inch) (2nd generation)
     ⇢ iPad Pro (10.5-inch)
     ⇢ iPad (6th generation)
     ⇢ iPad Pro (11-inch)
     ⇢ iPad Pro (12.9-inch) (3rd generation)
     ⇢ Apple TV
     ⇢ Apple TV 4K
     ⇢ Apple TV 4K (at 1080p)
     ⇢ Apple Watch - 38mm
     ⇢ Apple Watch - 42mm
     ⇢ Apple Watch Series 2 - 38mm
     ⇢ Apple Watch Series 2 - 42mm
     ⇢ Apple Watch Series 3 - 38mm
     ⇢ Apple Watch Series 3 - 42mm
     ⇢ Apple Watch Series 4 - 40mm
     ⇢ Apple Watch Series 4 - 44mm
 ► done
```

You can register runtimes or devices

```
$ XcodeTool simulator register 

Register devices or runtimes

Optional:
  --help  current screen

Sub-commands:
  runtimes  Register runtimes
  devices   Register devices
```
```
$ XcodeTool simulator register runtimes --list="iOS 8.4,iOS 9.3,iOS 10.3"

 ► Register runtimes
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 39 devices
     ✔︎ found 13 runtimes
   ► Add
     ✔︎ create simulator: iOS 8.4 - iPhone 4s
     ✔︎ create simulator: iOS 8.4 - iPhone 5
     ✔︎ create simulator: iOS 8.4 - iPhone 5s
     ✔︎ create simulator: iOS 8.4 - iPhone 6
     ✔︎ create simulator: iOS 8.4 - iPhone 6 Plus
     ✔︎ create simulator: iOS 8.4 - iPad 2
     ✔︎ create simulator: iOS 8.4 - iPad Retina
     ✔︎ create simulator: iOS 8.4 - iPad Air
     ✔︎ create simulator: iOS 8.4 - iPad Air 2
     ✔︎ create simulator: iOS 9.3 - iPhone 4s
     ✔︎ create simulator: iOS 9.3 - iPhone 5
     ✔︎ create simulator: iOS 9.3 - iPhone 5s
     ✔︎ create simulator: iOS 9.3 - iPhone 6
     ✔︎ create simulator: iOS 9.3 - iPhone 6 Plus
     ✔︎ create simulator: iOS 9.3 - iPhone 6s
     ✔︎ create simulator: iOS 9.3 - iPhone 6s Plus
     ✔︎ create simulator: iOS 9.3 - iPhone SE
     ✔︎ create simulator: iOS 9.3 - iPad 2
     ✔︎ create simulator: iOS 9.3 - iPad Retina
     ✔︎ create simulator: iOS 9.3 - iPad Air
     ✔︎ create simulator: iOS 9.3 - iPad Air 2
     ✔︎ create simulator: iOS 9.3 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 10.3 - iPhone 5
     ✔︎ create simulator: iOS 10.3 - iPhone 5s
     ✔︎ create simulator: iOS 10.3 - iPhone 6
     ✔︎ create simulator: iOS 10.3 - iPhone 6 Plus
     ✔︎ create simulator: iOS 10.3 - iPhone 6s
     ✔︎ create simulator: iOS 10.3 - iPhone 6s Plus
     ✔︎ create simulator: iOS 10.3 - iPhone 7
     ✔︎ create simulator: iOS 10.3 - iPhone 7 Plus
     ✔︎ create simulator: iOS 10.3 - iPhone SE
     ✔︎ create simulator: iOS 10.3 - iPad Air
     ✔︎ create simulator: iOS 10.3 - iPad Air 2
     ✔︎ create simulator: iOS 10.3 - iPad (5th generation)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (10.5-inch)
 ► done
```
```
$ XcodeTool simulator register devices --list="iPhone 4s,iPhone 5s,iPhone 6"

 ► Register devices
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 39 devices
     ✔︎ found 13 runtimes
   ► Add
     ✔︎ create simulator: iOS 8.4 - iPhone 4s
     ✔︎ create simulator: iOS 8.4 - iPhone 5s
     ✔︎ create simulator: iOS 8.4 - iPhone 6
     ✔︎ create simulator: iOS 9.3 - iPhone 4s
     ✔︎ create simulator: iOS 9.3 - iPhone 5s
     ✔︎ create simulator: iOS 9.3 - iPhone 6
     ✔︎ create simulator: iOS 10.3 - iPhone 5s
     ✔︎ create simulator: iOS 10.3 - iPhone 6
     ✔︎ create simulator: iOS 11.3 - iPhone 5s
     ✔︎ create simulator: iOS 11.3 - iPhone 6
     ✔︎ create simulator: iOS 11.4 - iPhone 5s
     ✔︎ create simulator: iOS 11.4 - iPhone 6
     ✔︎ create simulator: iOS 12.0 - iPhone 5s
     ✔︎ create simulator: iOS 12.0 - iPhone 6
     ✔︎ create simulator: iOS 12.1 - iPhone 5s
     ✔︎ create simulator: iOS 12.1 - iPhone 6
 ► done
```

You can unregister runtimes or devices

```
$ XcodeTool simulator unregister 

Unregister devices or runtimes

Optional:
  --help  current screen

Sub-commands:
  runtimes  Unregister runtimes
  devices   Unregister devices
```
```
$ XcodeTool simulator unregister runtimes --list="iOS 8.4,iOS 9.3,iOS 10.3"

 ► Unregister runtimes
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 38 devices
   ► Unregister
     ✔︎ iOS 8.4 - iPhone 4s
     ✔︎ iOS 8.4 - iPhone 5
     ✔︎ iOS 8.4 - iPhone 5s
     ✔︎ iOS 8.4 - iPhone 6
     ✔︎ iOS 8.4 - iPhone 6 Plus
     ✔︎ iOS 8.4 - iPad 2
     ✔︎ iOS 8.4 - iPad Retina
     ✔︎ iOS 8.4 - iPad Air
     ✔︎ iOS 8.4 - iPad Air 2
     ✔︎ iOS 9.3 - iPhone 4s
     ✔︎ iOS 9.3 - iPhone 5
     ✔︎ iOS 9.3 - iPhone 5s
     ✔︎ iOS 9.3 - iPhone 6
     ✔︎ iOS 9.3 - iPhone 6 Plus
     ✔︎ iOS 9.3 - iPhone 6s
     ✔︎ iOS 9.3 - iPhone 6s Plus
     ✔︎ iOS 9.3 - iPhone SE
     ✔︎ iOS 9.3 - iPad 2
     ✔︎ iOS 9.3 - iPad Retina
     ✔︎ iOS 9.3 - iPad Air
     ✔︎ iOS 9.3 - iPad Air 2
     ✔︎ iOS 9.3 - iPad Pro (12.9-inch)
     ✔︎ iOS 10.3 - iPhone 5
     ✔︎ iOS 10.3 - iPhone 5s
     ✔︎ iOS 10.3 - iPhone 6
     ✔︎ iOS 10.3 - iPhone 6 Plus
     ✔︎ iOS 10.3 - iPhone 6s
     ✔︎ iOS 10.3 - iPhone 6s Plus
     ✔︎ iOS 10.3 - iPhone 7
     ✔︎ iOS 10.3 - iPhone 7 Plus
     ✔︎ iOS 10.3 - iPhone SE
     ✔︎ iOS 10.3 - iPad Air
     ✔︎ iOS 10.3 - iPad Air 2
     ✔︎ iOS 10.3 - iPad (5th generation)
     ✔︎ iOS 10.3 - iPad Pro (9.7-inch)
     ✔︎ iOS 10.3 - iPad Pro (12.9-inch)
     ✔︎ iOS 10.3 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ iOS 10.3 - iPad Pro (10.5-inch)
 ► done
```
```
$ XcodeTool simulator unregister devices --list="iPhone 4s,iPhone 5s,iPhone 6"

 ► Unregister devices
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 16 devices
   ► Unregister
     ✔︎ iOS 8.4 - iPhone 4s
     ✔︎ iOS 8.4 - iPhone 5s
     ✔︎ iOS 8.4 - iPhone 6
     ✔︎ iOS 9.3 - iPhone 4s
     ✔︎ iOS 9.3 - iPhone 5s
     ✔︎ iOS 9.3 - iPhone 6
     ✔︎ iOS 10.3 - iPhone 5s
     ✔︎ iOS 10.3 - iPhone 6
     ✔︎ iOS 11.3 - iPhone 5s
     ✔︎ iOS 11.3 - iPhone 6
     ✔︎ iOS 11.4 - iPhone 5s
     ✔︎ iOS 11.4 - iPhone 6
     ✔︎ iOS 12.0 - iPhone 5s
     ✔︎ iOS 12.0 - iPhone 6
     ✔︎ iOS 12.1 - iPhone 5s
     ✔︎ iOS 12.1 - iPhone 6
 ► done
```
This command will regenerate all simulators 

```
$ XcodeTool simulator regenerate

 ► Regenerate all simulators
   ► Xcode
     ✔︎ found Xcode 10.1
   ► Scanning
     ✔︎ found 39 devices
     ✔︎ found 13 runtimes
     ✔︎ no simulators
   ► Create new simulators
     ✔︎ create simulator: iOS 8.4 - iPhone 4s
     ✔︎ create simulator: iOS 8.4 - iPhone 5
     ✔︎ create simulator: iOS 8.4 - iPhone 5s
     ✔︎ create simulator: iOS 8.4 - iPhone 6
     ✔︎ create simulator: iOS 8.4 - iPhone 6 Plus
     ✔︎ create simulator: iOS 8.4 - iPad 2
     ✔︎ create simulator: iOS 8.4 - iPad Retina
     ✔︎ create simulator: iOS 8.4 - iPad Air
     ✔︎ create simulator: iOS 8.4 - iPad Air 2
     ✔︎ create simulator: iOS 9.3 - iPhone 4s
     ✔︎ create simulator: iOS 9.3 - iPhone 5
     ✔︎ create simulator: iOS 9.3 - iPhone 5s
     ✔︎ create simulator: iOS 9.3 - iPhone 6
     ✔︎ create simulator: iOS 9.3 - iPhone 6 Plus
     ✔︎ create simulator: iOS 9.3 - iPhone 6s
     ✔︎ create simulator: iOS 9.3 - iPhone 6s Plus
     ✔︎ create simulator: iOS 9.3 - iPhone SE
     ✔︎ create simulator: iOS 9.3 - iPad 2
     ✔︎ create simulator: iOS 9.3 - iPad Retina
     ✔︎ create simulator: iOS 9.3 - iPad Air
     ✔︎ create simulator: iOS 9.3 - iPad Air 2
     ✔︎ create simulator: iOS 9.3 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 10.3 - iPhone 5
     ✔︎ create simulator: iOS 10.3 - iPhone 5s
     ✔︎ create simulator: iOS 10.3 - iPhone 6
     ✔︎ create simulator: iOS 10.3 - iPhone 6 Plus
     ✔︎ create simulator: iOS 10.3 - iPhone 6s
     ✔︎ create simulator: iOS 10.3 - iPhone 6s Plus
     ✔︎ create simulator: iOS 10.3 - iPhone 7
     ✔︎ create simulator: iOS 10.3 - iPhone 7 Plus
     ✔︎ create simulator: iOS 10.3 - iPhone SE
     ✔︎ create simulator: iOS 10.3 - iPad Air
     ✔︎ create simulator: iOS 10.3 - iPad Air 2
     ✔︎ create simulator: iOS 10.3 - iPad (5th generation)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 10.3 - iPad Pro (10.5-inch)
     ✔︎ create simulator: iOS 11.3 - iPhone 5s
     ✔︎ create simulator: iOS 11.3 - iPhone 6
     ✔︎ create simulator: iOS 11.3 - iPhone 6 Plus
     ✔︎ create simulator: iOS 11.3 - iPhone 6s
     ✔︎ create simulator: iOS 11.3 - iPhone 6s Plus
     ✔︎ create simulator: iOS 11.3 - iPhone 7
     ✔︎ create simulator: iOS 11.3 - iPhone 7 Plus
     ✔︎ create simulator: iOS 11.3 - iPhone 8
     ✔︎ create simulator: iOS 11.3 - iPhone 8 Plus
     ✔︎ create simulator: iOS 11.3 - iPhone SE
     ✔︎ create simulator: iOS 11.3 - iPhone X
     ✔︎ create simulator: iOS 11.3 - iPad Air
     ✔︎ create simulator: iOS 11.3 - iPad Air 2
     ✔︎ create simulator: iOS 11.3 - iPad (5th generation)
     ✔︎ create simulator: iOS 11.3 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 11.3 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 11.3 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 11.3 - iPad Pro (10.5-inch)
     ✔︎ create simulator: iOS 11.3 - iPad (6th generation)
     ✔︎ create simulator: iOS 11.4 - iPhone 5s
     ✔︎ create simulator: iOS 11.4 - iPhone 6
     ✔︎ create simulator: iOS 11.4 - iPhone 6 Plus
     ✔︎ create simulator: iOS 11.4 - iPhone 6s
     ✔︎ create simulator: iOS 11.4 - iPhone 6s Plus
     ✔︎ create simulator: iOS 11.4 - iPhone 7
     ✔︎ create simulator: iOS 11.4 - iPhone 7 Plus
     ✔︎ create simulator: iOS 11.4 - iPhone 8
     ✔︎ create simulator: iOS 11.4 - iPhone 8 Plus
     ✔︎ create simulator: iOS 11.4 - iPhone SE
     ✔︎ create simulator: iOS 11.4 - iPhone X
     ✔︎ create simulator: iOS 11.4 - iPad Air
     ✔︎ create simulator: iOS 11.4 - iPad Air 2
     ✔︎ create simulator: iOS 11.4 - iPad (5th generation)
     ✔︎ create simulator: iOS 11.4 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 11.4 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 11.4 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 11.4 - iPad Pro (10.5-inch)
     ✔︎ create simulator: iOS 11.4 - iPad (6th generation)
     ✔︎ create simulator: iOS 12.0 - iPhone 5s
     ✔︎ create simulator: iOS 12.0 - iPhone 6
     ✔︎ create simulator: iOS 12.0 - iPhone 6 Plus
     ✔︎ create simulator: iOS 12.0 - iPhone 6s
     ✔︎ create simulator: iOS 12.0 - iPhone 6s Plus
     ✔︎ create simulator: iOS 12.0 - iPhone 7
     ✔︎ create simulator: iOS 12.0 - iPhone 7 Plus
     ✔︎ create simulator: iOS 12.0 - iPhone 8
     ✔︎ create simulator: iOS 12.0 - iPhone 8 Plus
     ✔︎ create simulator: iOS 12.0 - iPhone SE
     ✔︎ create simulator: iOS 12.0 - iPhone X
     ✔︎ create simulator: iOS 12.0 - iPhone Xs
     ✔︎ create simulator: iOS 12.0 - iPhone Xs Max
     ✔︎ create simulator: iOS 12.0 - iPhone Xʀ
     ✔︎ create simulator: iOS 12.0 - iPad Air
     ✔︎ create simulator: iOS 12.0 - iPad Air 2
     ✔︎ create simulator: iOS 12.0 - iPad (5th generation)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (10.5-inch)
     ✔︎ create simulator: iOS 12.0 - iPad (6th generation)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (11-inch)
     ✔︎ create simulator: iOS 12.0 - iPad Pro (12.9-inch) (3rd generation)
     ✔︎ create simulator: iOS 12.1 - iPhone 5s
     ✔︎ create simulator: iOS 12.1 - iPhone 6
     ✔︎ create simulator: iOS 12.1 - iPhone 6 Plus
     ✔︎ create simulator: iOS 12.1 - iPhone 6s
     ✔︎ create simulator: iOS 12.1 - iPhone 6s Plus
     ✔︎ create simulator: iOS 12.1 - iPhone 7
     ✔︎ create simulator: iOS 12.1 - iPhone 7 Plus
     ✔︎ create simulator: iOS 12.1 - iPhone 8
     ✔︎ create simulator: iOS 12.1 - iPhone 8 Plus
     ✔︎ create simulator: iOS 12.1 - iPhone SE
     ✔︎ create simulator: iOS 12.1 - iPhone X
     ✔︎ create simulator: iOS 12.1 - iPhone Xs
     ✔︎ create simulator: iOS 12.1 - iPhone Xs Max
     ✔︎ create simulator: iOS 12.1 - iPhone Xʀ
     ✔︎ create simulator: iOS 12.1 - iPad Air
     ✔︎ create simulator: iOS 12.1 - iPad Air 2
     ✔︎ create simulator: iOS 12.1 - iPad (5th generation)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (9.7-inch)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (12.9-inch)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (12.9-inch) (2nd generation)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (10.5-inch)
     ✔︎ create simulator: iOS 12.1 - iPad (6th generation)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (11-inch)
     ✔︎ create simulator: iOS 12.1 - iPad Pro (12.9-inch) (3rd generation)
     ✔︎ create simulator: tvOS 10.2 - Apple TV
     ✔︎ create simulator: tvOS 11.4 - Apple TV
     ✔︎ create simulator: tvOS 11.4 - Apple TV 4K
     ✔︎ create simulator: tvOS 11.4 - Apple TV 4K (at 1080p)
     ✔︎ create simulator: tvOS 12.1 - Apple TV
     ✔︎ create simulator: tvOS 12.1 - Apple TV 4K
     ✔︎ create simulator: tvOS 12.1 - Apple TV 4K (at 1080p)
     ✔︎ create simulator: watchOS 3.2 - Apple Watch - 38mm
     ✔︎ create simulator: watchOS 3.2 - Apple Watch - 42mm
     ✔︎ create simulator: watchOS 3.2 - Apple Watch Series 2 - 38mm
     ✔︎ create simulator: watchOS 3.2 - Apple Watch Series 2 - 42mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch - 38mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch - 42mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 2 - 38mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 2 - 42mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 3 - 38mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 3 - 42mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 4 - 40mm
     ✔︎ create simulator: watchOS 4.2 - Apple Watch Series 4 - 44mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 2 - 38mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 2 - 42mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 3 - 38mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 3 - 42mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 4 - 40mm
     ✔︎ create simulator: watchOS 5.1 - Apple Watch Series 4 - 44mm
 ► done
```

For example on iOS project you will see

![image](https://user-images.githubusercontent.com/1082222/49857664-6f3dc700-fdf3-11e8-9ad5-53a6ddddeeeb.png)
