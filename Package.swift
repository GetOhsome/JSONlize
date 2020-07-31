// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONlize",
    products: [
        .library(
            name: "JSONlize",
            targets: ["JSONlize"]),
    ],
    targets: [
        .target(
            name: "JSONlize",
            dependencies: []),
    ]
)
