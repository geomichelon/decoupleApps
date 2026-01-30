import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("16.0")

func appTarget(
    name: String,
    bundleId: String,
    sources: SourceFilesList,
    dependencies: [TargetDependency]
) -> Target {
    .target(
        name: name,
        destinations: .iOS,
        product: .app,
        bundleId: bundleId,
        deploymentTargets: deploymentTargets,
        infoPlist: .default,
        sources: sources,
        resources: [],
        dependencies: dependencies
    )
}

let project = Project(
    name: "DecoupledApps-iOS-Tuist",
    organizationName: "George Michelon",
    packages: [
        .package(path: "Modules")
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.9",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0"
        ]
    ),
    targets: [
        appTarget(
            name: "SuperApp",
            bundleId: "com.decoupledapps.superapp",
            sources: "Apps/SuperApp/**",
            dependencies: [
                .package(product: "CatalogFeature"),
                .package(product: "CheckoutFeature"),
                .package(product: "ProfileFeature"),
                .package(product: "SharedContracts"),
                .package(product: "InfraAuth")
            ]
        ),
        appTarget(
            name: "CatalogApp",
            bundleId: "com.decoupledapps.catalog",
            sources: "Apps/CatalogApp/**",
            dependencies: [
                .package(product: "CatalogFeature"),
                .package(product: "SharedContracts")
            ]
        ),
        appTarget(
            name: "CheckoutApp",
            bundleId: "com.decoupledapps.checkout",
            sources: "Apps/CheckoutApp/**",
            dependencies: [
                .package(product: "CheckoutFeature"),
                .package(product: "SharedContracts"),
                .package(product: "InfraAuth")
            ]
        ),
        appTarget(
            name: "ProfileApp",
            bundleId: "com.decoupledapps.profile",
            sources: "Apps/ProfileApp/**",
            dependencies: [
                .package(product: "ProfileFeature"),
                .package(product: "InfraAuth")
            ]
        )
    ]
)
