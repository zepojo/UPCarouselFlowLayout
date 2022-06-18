// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UPCarouselFlowLayout",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "UPCarouselFlowLayout",
                 targets: ["UPCarouselFlowLayout"])
    ],
    targets: [
        .target(name: "UPCarouselFlowLayout",
                path: "UPCarouselFlowLayout")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

