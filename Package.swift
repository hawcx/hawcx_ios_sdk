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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.2.2/HawcxFramework.xcframework.zip",
            checksum: "9637230848639ebf8d6a0c41836a9276dd869ad6b4b2aea3fdde45ae62388a84"
        )
    ]
)
