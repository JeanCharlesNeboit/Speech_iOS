// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppDependencies",
    platforms: [ .iOS(.v14) ],
    products: [
        .library(name: "AppDependencies",
                 type: .dynamic,
                 targets: ["AppDependencies"])
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "7.9.0")),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", .upToNextMajor(from: "9.0.2")),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .upToNextMajor(from: "10.5.1")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.1.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(name: "AppDependencies",
                dependencies: [
                    .product(name: "FirebaseAnalytics", package: "Firebase"),
                    "SwiftMessages",
                    .product(name: "Realm", package: "Realm"),
                    .product(name: "RealmSwift", package: "Realm"),
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift"),
                    .product(name: "RxDataSources", package: "RxDataSources")
                ],
                path: ".",
                sources: ["AppDependencies.swift"])
    ]
)
