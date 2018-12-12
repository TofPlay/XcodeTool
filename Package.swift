// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "XcodeTool",
    dependencies: [
        .package(url: "https://github.com/TofPlay/ScriptKit.git", .exact("1.0.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "XcodeTool",
            dependencies: ["ScriptKit"]),
    ],
  swiftLanguageVersions: [.v4_2]
)
