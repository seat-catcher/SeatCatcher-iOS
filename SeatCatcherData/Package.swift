// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeatCatcherData",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SeatCatcherData",
            targets: ["SeatCatcherData"]
        ),
    ],
    dependencies: [
        .package(name: "SeatCatcherDomain", path: "../SeatCatcherDomain"),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SeatCatcherData",
            dependencies: [
                "SeatCatcherDomain",
                "Moya"
            ]
        ),
        .testTarget(
            name: "SeatCatcherDataTests",
            dependencies: ["SeatCatcherData"]
        ),
    ]
)
