// swift-tools-version: 5.9
// Author: George Michelon
import PackageDescription

let package = Package(
    name: "DecoupledAppsModules",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "SharedContracts", targets: ["SharedContracts"]),
        .library(name: "CatalogDomain", targets: ["CatalogDomain"]),
        .library(name: "CheckoutDomain", targets: ["CheckoutDomain"]),
        .library(name: "ProfileDomain", targets: ["ProfileDomain"]),
        .library(name: "CatalogFeature", targets: ["CatalogFeature"]),
        .library(name: "CheckoutFeature", targets: ["CheckoutFeature"]),
        .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
        .library(name: "InfraNetwork", targets: ["InfraNetwork"]),
        .library(name: "InfraPersistence", targets: ["InfraPersistence"]),
        .library(name: "InfraAnalytics", targets: ["InfraAnalytics"]),
        .library(name: "InfraPayments", targets: ["InfraPayments"]),
        .library(name: "InfraAuth", targets: ["InfraAuth"])
    ],
    targets: [
        .target(name: "DesignSystem"),
        .target(name: "Core"),
        .target(name: "SharedContracts"),
        .target(name: "CatalogDomain", dependencies: ["SharedContracts"]),
        .target(name: "CheckoutDomain", dependencies: ["SharedContracts"]),
        .target(name: "ProfileDomain", dependencies: ["SharedContracts"]),
        .target(name: "CatalogFeature", dependencies: ["CatalogDomain", "SharedContracts", "DesignSystem"]),
        .target(name: "CheckoutFeature", dependencies: ["CheckoutDomain", "SharedContracts", "DesignSystem"]),
        .target(name: "ProfileFeature", dependencies: ["ProfileDomain", "SharedContracts", "DesignSystem"]),
        .target(name: "InfraNetwork", dependencies: ["Core", "SharedContracts"]),
        .target(name: "InfraPersistence", dependencies: ["Core", "SharedContracts"]),
        .target(name: "InfraAnalytics", dependencies: ["Core", "SharedContracts"]),
        .target(name: "InfraPayments", dependencies: ["Core", "SharedContracts"]),
        .target(name: "InfraAuth", dependencies: ["Core", "SharedContracts"]),
        .testTarget(name: "SharedContractsTests", dependencies: ["SharedContracts"]),
        .testTarget(name: "CatalogDomainTests", dependencies: ["CatalogDomain"]),
        .testTarget(name: "CheckoutDomainTests", dependencies: ["CheckoutDomain"]),
        .testTarget(name: "ProfileDomainTests", dependencies: ["ProfileDomain"])
    ]
)
