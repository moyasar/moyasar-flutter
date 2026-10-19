// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "moyasar",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "moyasar", targets: ["moyasar"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "moyasar",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
