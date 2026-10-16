// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftDataMultivitamin",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "SwiftDataMultivitamin",
            path: ".",
            exclude: [
                "CONTRIBUTING.md",
                "DISCOVERIES.md",
                "LICENSE",
                "README.md",
                "Tests",
                "features/01-model-basics/README.md",
                "features/01-model-basics/01-tbilisi-quince-commission/README.md",
                "features/01-model-basics/02-legnica-copper-blank/README.md",
                "features/01-model-basics/03-haarlem-bite-note/README.md",
                "features/01-model-basics/04-barcelona-bone-black/README.md",
                "features/01-model-basics/05-fabriano-damp-pack/README.md",
                "features/01-model-basics/06-verona-crate-and-waybill/README.md",
                "features/01-model-basics/07-tbilisi-desk-briefing/README.md",
                "features/01-model-basics/08-tbilisi-plate-receipt/README.md",
                "features/01-model-basics/09-barcelona-two-grinds/README.md",
                "features/01-model-basics/10-fabriano-mill-schema/README.md",
                "features/01-model-basics/11-vera-district-shelf-card/README.md",
                "features/01-model-basics/12-albertina-bench-slip/README.md",
                "features/01-model-basics/13-morning-handover-folder/README.md",
                "features/02-attributes/README.md",
                "features/02-attributes/01-lucanas-ear-mark/README.md",
                "features/02-attributes/02-arequipa-weigh-photo/README.md",
                "features/02-attributes/03-puno-lot-spotlight/README.md",
                "features/02-attributes/04-sucre-dye-note/README.md",
                "features/02-attributes/05-lucanas-agreed-price/README.md",
                "features/02-attributes/06-arequipa-renamed-kilos/README.md",
                "features/02-attributes/07-arequipa-ledger-reprint/README.md",
                "features/02-attributes/08-la-paz-spoken-markup/README.md",
                "features/02-attributes/09-tarabuco-micron-reading/README.md",
                "features/02-attributes/10-puno-bale-code/README.md",
                "features/02-attributes/11-puno-seal-and-photo/README.md",
                "features/02-attributes/12-lucanas-second-card/README.md",
                "features/02-attributes/13-la-paz-morning-folder/README.md"
            ],
            sources: [
                "App",
                "features/01-model-basics",
                "features/02-attributes"
            ]
        ),
        .testTarget(
            name: "SwiftDataMultivitaminTests",
            dependencies: ["SwiftDataMultivitamin"],
            path: "Tests/SwiftDataMultivitaminTests"
        )
    ]
)
