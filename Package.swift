// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONLocalize",
    products: [
        .library(
            name: "JSONLocalize",
            targets: ["JSONLocalize"]),
    ],
    targets: [
        .target(
            name: "JSONLocalize",
            dependencies: []),
    ]
)
