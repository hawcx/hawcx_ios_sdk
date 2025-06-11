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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/4.0.0/HawcxFramework.xcframework.zip",
            checksum: "74a23567d992ecee4b50b041d1e2ee5e606f9af06d9b33255267f18e54a0cdfb"
        )
    ]
)
