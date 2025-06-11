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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/4.0.1/HawcxFramework.xcframework.zip",
            checksum: "dc54a7ae0c9881bd5ee271fd37ca6b18b775ff92a7982c18ecb2aae509618b80"
        )
    ]
)
