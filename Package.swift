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
            checksum: "1ac1d93235a0551c46740ea8e102c9da758d03dad93bef88861203021347f15d"
        )
    ]
)