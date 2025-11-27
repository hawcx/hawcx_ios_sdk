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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.2.0/HawcxFramework.xcframework.zip",
            checksum: "ffaabd646731c6875c2d57c60dda23a725b608ffac638b77ac5dd9119be749d9"
        )
    ]
)
