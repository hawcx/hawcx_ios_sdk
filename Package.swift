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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/6.0.3/HawcxFramework.xcframework.zip",
            checksum: "8993b3f902c0e3277028feaf1fb8b5726b1f6a8628e87832d6d4ace9570d48c8"
        )
    ]
)
