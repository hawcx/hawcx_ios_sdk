import PackageDescription

let package = Package(
    name: "HawcxSDK",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HawcxSDK",
            targets: ["HawcxSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "HawcxSDK",
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/1.0.0/HawcxSDK.xcframework.zip",
            checksum: "a3116363c0bfb4dc52eb74131b66014a619c494d2a19970092bf78d10cbb4caf"
        )
    ]
)