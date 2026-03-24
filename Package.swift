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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/6.0.1/HawcxFramework.xcframework.zip",
            checksum: "1dd087785546318c6bc76f152449e481adffd94beda24b2c7f9fbe62e3ba72c5"
        )
    ]
)
