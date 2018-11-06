<p align="center">
    <img src="https://user-images.githubusercontent.com/1082222/30913661-4900771c-a391-11e7-9f4c-e2d51ddd451b.jpg" alt="ScriptKit" />
</p>


![macOS](https://img.shields.io/badge/macOS-10.13.6-6193DF.svg)
![Xcode](https://img.shields.io/badge/Xcode-10.1-6193DF.svg)
![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg) 
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) 
![Plaform](https://img.shields.io/badge/Platform-macOS-lightgrey.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 

---

## Table of contents

* [What is XcodeTool?](#what-is-xcodetool)
* [Environment](#environment)
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

![image](https://user-images.githubusercontent.com/1082222/32665691-731d98ba-c635-11e7-9ecb-fa66b2719657.png)

# Command project

![image](https://user-images.githubusercontent.com/1082222/32666510-f0f47b08-c637-11e7-9eaa-5c98bc180ab7.png)

With this command you can rename a class or a project. Change the git url or rename a git submodule.

# Command template

![image](https://user-images.githubusercontent.com/1082222/27759376-cc0c1bae-5e2f-11e7-843b-80680183f334.png)

`template` is a command to create projets base on template projects. 
You can use predefined templates provide with XcodeTool. You can also create you own sources and your own templates.

## Predefined templates

### Create a new component cross-platform

This template is base on tutorial: [Swift Cross Platform Framework](https://github.com/TofPlay/SwiftCrossPlatformFramework)

1. Create your component with the template `ComponentCrossPlatform`

![test](https://user-images.githubusercontent.com/1082222/32666874-32bf647a-c639-11e7-8ec1-1c31cec19d18.jpg)

XcodeTool will generate this project for you:

![image](https://user-images.githubusercontent.com/1082222/27770435-13626b06-5f3f-11e7-8eaf-dbd0860369d6.png)

2. Open your first component cross-platform with Xcode

![image](https://user-images.githubusercontent.com/1082222/27770423-d28803ac-5f3e-11e7-9186-b8e1ffa08492.png)

### Create a command line tool

1. To generate your first command line tool project:

![test1](https://user-images.githubusercontent.com/1082222/32666965-8db685fc-c639-11e7-881a-ff32eeb9bee9.jpg)

XcodeTool will generate this project for you:

![image](https://user-images.githubusercontent.com/1082222/27724973-9288ac46-5d74-11e7-8d8a-b630a7c92187.png)

2. Open your first command line tool with Xcode

![image](https://user-images.githubusercontent.com/1082222/27725251-be0f3ac8-5d75-11e7-8923-adeec5b8cade.png) 


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
$ XcodeTool template gen --name=NewTemplate --url=https://github.com/JohnDoe/NewTemplate.xtemplate.git --description="My new crazy template" --original=NewTemplate --version=1.0.0 --author-"John Doe"

 ► Template generate json
   ✔︎ json file for the new template saved at '/Users/johnDoe/projects/github/NewSourceTemplates/NewTemplate.json'
 ► done
```

6. Commit your `NewTemplate.json` on https://github.com/JohnDoe/NewSourceTemplates

7. Declare your source for XcodeTool

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

![image](https://user-images.githubusercontent.com/1082222/32667188-482c7608-c63a-11e7-8dd1-199ccd364b45.png)

This command will regenerate all simulators 

![image](https://user-images.githubusercontent.com/1082222/32666338-662f0628-c637-11e7-97f4-9ff5d3fefd05.png)

For example on iOS project you will see

![image](https://user-images.githubusercontent.com/1082222/32665911-140eabf6-c636-11e7-9ddd-2c9b589c916e.png)

