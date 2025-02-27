// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGSwiftUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SVGSwiftUI",
            targets: ["SVGSwiftUI"]
        ),
    ],
    targets: [
        .target(
            name: "SVGSwiftUI",
            dependencies: []
        ),
    ]
)
