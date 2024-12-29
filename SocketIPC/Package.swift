// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocketIPC",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SocketIPC",
            targets: ["SocketIPC"]),
        .executable(
            name: "HostApp",
            targets: [
                "HostApp"
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMinor(from: "16.1.1")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SocketIPC",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift")
            ]),
        .target(
            name: "HostApp",
            dependencies: [
                "SocketIPC",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "SocketIPCTests",
            dependencies: ["SocketIPC"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
