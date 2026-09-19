// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Eta",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Eta",
            targets: ["Eta"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.27.0"),
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Eta",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "Markdown", package: "swift-markdown")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "EtaTests",
            dependencies: ["Eta"],
            path: "EtaTests"
        )
    ]
)

