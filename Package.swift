// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "hawcx_ios_sdk", 
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HawcxSDK",
            targets: ["HawcxFramework"]),
    ],
    targets: [
        .binaryTarget(
            name: "HawcxFramework",
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/1.0.1/HawcxFramework.xcframework.zip",
            checksum: "a8d7279575ba3e65e3f061513a59149c6ddfe22309a996e7819136de92613e6a"
        )
    ]
)