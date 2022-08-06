// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AntsInMyPants",
    platforms: [
        .macOS("12"),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AntsInMyPants",
            targets: ["AntsInMyPants"]),
    ],
    targets: [
        .target(name: "AntsInMyPants")
    ]
)
