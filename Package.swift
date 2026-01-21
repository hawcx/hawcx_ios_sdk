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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.2.5/HawcxFramework.xcframework.zip",
            checksum: "086301154319fe4bfefad19fd25ec79c9aad8eb235553833c10f3d0e313e4b03"
        )
    ]
)
