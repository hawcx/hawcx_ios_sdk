// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "hawcx_ios_sdk", 
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HawcxFramework",
            targets: ["HawcxFramework"]),
    ],
    targets: [
        .binaryTarget(
            name: "HawcxFramework",
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.2.1/HawcxFramework.xcframework.zip",
            checksum: "4b4a19514494f7470bdff2296597e7694f9b3584766c2486e53ed4ea92ad3900"
        )
    ]
)
