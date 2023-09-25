// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Repository", targets: ["Repository"]),
        .library(name: "Models", targets: ["Models"]),
    ],
    dependencies: Dependencies.allCases.map(\.package),
    targets: [
        .target(name: "Models"),
        .target(
            name: "APIProvider",
            dependencies: [
                "Models",
                Dependencies.SwiftFP.target
            ]),
        .target(
            name: "RealmProvider",
            dependencies: [
                Dependencies.Realm.target
            ]),
        .target(
            name: "Repository",
            dependencies: [
                "APIProvider",
                "RealmProvider"
            ]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "Repository",
                "APIProvider",
                "Models"
            ]),
    ]
)

//MARK: - Dependencies
fileprivate enum Dependencies: CaseIterable {
    case SwiftFP
    case Realm
    
    var package: Package.Dependency {
        switch self {
        case .SwiftFP: return .package(url: "https://github.com/ShapovalovIlya/SwiftFP.git", branch: "main")
        case .Realm: return .package(url: "https://github.com/realm/realm-swift.git", from: "10.42.3")
        }
    }
    
    var target: Target.Dependency {
        switch self {
        case .SwiftFP: return .product(name: "SwiftFP", package: "SwiftFP")
        case .Realm: return .product(name: "RealmSwift", package: "realm-swift")
        }
    }
}
