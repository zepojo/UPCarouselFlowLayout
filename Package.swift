// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "UPCarouselFlowLayout",
    platforms: [
        .iOS(.v11),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "UPCarouselFlowLayout",
            type: .static,
            targets: ["UPCarouselFlowLayout"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UPCarouselFlowLayout"
        )
    ]
)