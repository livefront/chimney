// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Keys",
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "3.2.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", from: "5.2.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "Keys",
            dependencies: [
                "KeychainAccess",
                "PathKit",
                "Stencil",
                "SwiftCLI",
                "Yams",
            ]),
        .testTarget(
            name: "KeysTests",
            dependencies: ["Keys"]),
    ]
)
