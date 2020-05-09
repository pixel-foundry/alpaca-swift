// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "Alpaca",
	targets: [
		.target(name: "Alpaca"),
		.testTarget(name: "Tests", dependencies: ["Alpaca"])
	]
)
