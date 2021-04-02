// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppDependencies",
    platforms: [ .iOS(.v11) ],
    products: [
        .library(name: "AppDependencies",
                 type: .dynamic,
                 targets: ["AppDependencies"])
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "7.9.0")),
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .upToNextMajor(from: "10.5.1")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.1.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/malcommac/SwiftDate.git", .upToNextMajor(from: "6.3.1")),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", .upToNextMajor(from: "9.0.2")),
        .package(name: "TinyConstraints", url: "https://github.com/roberthein/TinyConstraints.git", .upToNextMajor(from: "4.0.1"))
    ],
    targets: [
        .target(name: "AppDependencies",
                dependencies: [
                    .product(name: "FirebaseAnalytics", package: "Firebase"),
                    .product(name: "Realm", package: "Realm"),
                    .product(name: "RealmSwift", package: "Realm"),
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift"),
                    .product(name: "RxDataSources", package: "RxDataSources"),
                    .product(name: "RxKeyboard", package: "RxKeyboard"),
                    "SwiftDate",
                    "SwiftMessages",
                    "TinyConstraints"
                ],
                path: ".",
                sources: ["AppDependencies.swift"])
    ]
)
