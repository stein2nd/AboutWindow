// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = Package.init(
	name: "AboutWindow",
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(name: "AboutWindow", targets: [ "AboutWindow" ]),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/DaveWoodCom/XCGLogger.git", from: "7.0.1"),
		.package(url: "https://github.com/stein2nd/SwiftTryCatch.git", branch: "SPM25"),
		.package(url: "https://github.com/stein2nd/TransparentScroller.git", branch: "master"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(name: "AboutWindow", dependencies: []),
		.testTarget(name: "AboutWindowTests", dependencies: [ "AboutWindow" ]),
	]
)
