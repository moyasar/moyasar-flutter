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
    dependencies: [],
    targets: [
        .target(
            name: "moyasar",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
