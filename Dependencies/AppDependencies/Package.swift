// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppDependencies",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "AppDependencies",
            type: .dynamic,
            targets: ["AppDependencies"]
        )
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/malcommac/SwiftDate.git", .upToNextMajor(from: "6.3.1")),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", .upToNextMajor(from: "9.0.2")),
    ],
    targets: [
        .target(
            name: "AppDependencies",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "Firebase"),
                .product(name: "FirebaseCrashlytics", package: "Firebase"),
                "SwiftDate",
                "SwiftMessages",
            ],
            path: ".",
            sources: ["AppDependencies.swift"]
        )
    ]
)
