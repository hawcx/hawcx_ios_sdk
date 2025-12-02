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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.2.3/HawcxFramework.xcframework.zip",
            checksum: "5e1a29f2455186eef8c4f59c03a676ee876ea6566c2cd3eb56e7fcaa8703193d"
        )
    ]
)
