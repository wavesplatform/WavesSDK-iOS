// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WavesSDK",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
//        .library(
//            name: "Base58Encoder",
//            targets: ["Base58Encoder"]),
//        .library(
//            name: "Blake2",
//            targets: ["Blake2"]),
//        .library(
//            name: "Keccak",
//            targets: ["Keccak"]),
//        .library(
//            name: "Curve25519",
//            targets: ["Curve25519"]),
//        .library(
//            name: "WavesSDKCrypto",
//            targets: ["WavesSDKCrypto"]),
        .library(
            name: "WavesSDK",
            targets: ["WavesSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattgallagher/CwlUtils.git", from: Version(3, 0, 0)),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        ///
        /// Base 58 Encoder library
        ///
        .target(
            name: "Base58Encoder",
            dependencies: []),
        ///
        /// Blake 2 library
        ///
            .target(
                name: "Blake2",
                dependencies: []),
        ///
        /// Keccak library
        ///
            .target(
                name: "Keccak",
                dependencies: []),
        ///
        /// Curve 25519 library
        ///
        .target(
            name: "ed25519",
            dependencies: []),
        .target(
            name: "Curve25519",
            dependencies: ["ed25519"]),

        ///
        ///  WavesSDK Crypto library
        ///
        .target(
            name: "WavesSDKCrypto",
            dependencies: ["Keccak",
                           "Curve25519",
                           "Blake2",
                           "Base58Encoder"]),
        ///
        ///  WavesSDK library
        ///
        .target(
            name: "WavesSDK",
            dependencies: [
                "WavesSDKCrypto",
                "Moya",
                "RxSwift",
                "CwlUtils",
                .product(name: "RxMoya", package: "Moya")
            ]),
        .testTarget(
            name: "WavesSDKCryptoTests",
            dependencies: ["WavesSDKCrypto"]),
        .testTarget(
            name: "WavesSDKTests",
            dependencies: ["WavesSDK"]),
    ]
)
