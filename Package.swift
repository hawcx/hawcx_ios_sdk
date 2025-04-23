import PackageDescription

let package = Package(
    name: "HawcxSDK",
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
            url: "https://github.com/user-attachments/files/19874294/HawcxFramework.xcframework.zip",
            checksum: "a3116363c0bfb4dc52eb74131b66014a619c494d2a19970092bf78d10cbb4caf"
        )
    ]
)