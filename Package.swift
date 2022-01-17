// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swiftui-tabs-view",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(name: "SwiftUITabsView", targets: ["SwiftUITabsView"]),
  ],
  targets: [
    .target(name: "SwiftUITabsView"),
  ]
)
