// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UPCarouselFlowLayout",
    platforms: [ .iOS(.v8) ],
    products: [
        .library(
            name: "UPCarouselFlowLayout", targets: ["UPCarouselFlowLayout"])
        ],
        dependencies: [ ],
        targets: [
            .target(
                name: "UPCarouselFlowLayout",
                path: "UPCarouselFlowLayout",
                exclude: ["Info.plist", "UPCarouselFlowLayout.h"]),
                
    ]
)
