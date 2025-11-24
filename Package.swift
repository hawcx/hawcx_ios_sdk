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
            url: "https://github.com/hawcx/hawcx_ios_sdk/releases/download/5.1/HawcxFramework.xcframework.zip",
            checksum: "92c5129883b31ec8143eccee646a38446a92555bfcf62272cb2a95aef725e1b8"
        )
    ]
)
