// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapsIndoors-CrowdConnected",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MapsIndoors-CrowdConnected",
            targets: ["MapsIndoors-CrowdConnected"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MapsPeople/mapsindoors-core-ios.git", .upToNextMajor(from: "4.10.0")),
        .package(url: "https://github.com/crowdconnected/crowdconnected-core-ios.git", .upToNextMajor(from: "1.6.3")),
        .package(url: "https://github.com/crowdconnected/crowdconnected-ips-ios", .upToNextMajor(from: "1.6.3")),
    ],
    targets: [
        .target(
            name: "MapsIndoors-CrowdConnected",
            dependencies: [
                .product(name: "MapsIndoorsCore", package: "mapsindoors-core-ios"),
                .product(name: "CrowdConnectedCore", package: "crowdconnected-core-ios"),
                .product(name: "CrowdConnectedIPS", package: "crowdconnected-ips-ios"),
            ]),
        .testTarget(
            name: "MapsIndoors-CrowdConnectedTests",
            dependencies: ["MapsIndoors-CrowdConnected"]
        ),
    ]
)
