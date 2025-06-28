// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGKit",
    products: [
        .library(
            name: "SVGKit",
            targets: ["SVGKit"]
        )
    ],
    targets: [
        .target(name: "SVGKit"),
    ]
)
