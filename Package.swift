// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapsIndoors-CrowdConnected",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "MapsIndoors-CrowdConnected",
            targets: ["MapsIndoors-CrowdConnected"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MapsPeople/mapsindoors-core-ios.git", .upToNextMajor(from: "4.24.2")),
        .package(url: "https://github.com/crowdconnected/crowdconnected-sdk-swift-spm.git", .upToNextMajor(from: "3.3.0")),
    ],
    targets: [
        .target(
            name: "MapsIndoors-CrowdConnected",
            dependencies: [
                .product(name: "MapsIndoorsCore", package: "mapsindoors-core-ios"),
                .product(name: "CrowdConnectedCore", package: "crowdconnected-sdk-swift-spm"),
                .product(name: "CrowdConnectedIPS", package: "crowdconnected-sdk-swift-spm"),
                .product(name: "CrowdConnectedCoreBluetooth", package: "crowdconnected-sdk-swift-spm"),
                .product(name: "CrowdConnectedShared", package: "crowdconnected-sdk-swift-spm"),
            ]),
        .testTarget(
            name: "MapsIndoors-CrowdConnectedTests",
            dependencies: ["MapsIndoors-CrowdConnected"]
        ),
    ]
)
