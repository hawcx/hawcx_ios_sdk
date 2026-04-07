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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/6.0.2/HawcxFramework.xcframework.zip",
            checksum: "64fb4fe6af447f56c65b56bd566cb228a9b0fc939eff8daba41358416dda0584"
        )
    ]
)
