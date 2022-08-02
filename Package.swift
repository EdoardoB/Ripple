// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Ripple",
    products: [
        .executable(name: "Ripple", targets: ["Ripple"]),
    ],
    dependencies: [
        .package(url: "https://github.com/benoit-pereira-da-silva/CommandLine.git", from: "4.0.9"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.10.1")
    ],
    targets: [
        .target(name: "RippleKit", dependencies: ["PathKit"]),
        .target(name: "Ripple", dependencies: ["RippleKit", .product(name: "CommandLineKit", package: "CommandLine")]),
        .testTarget(name: "RippleKitTests", dependencies: ["RippleKit", "Spectre"]),
    ]
)
