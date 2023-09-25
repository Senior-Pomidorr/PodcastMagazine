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
        .library(name: "APIProvider", targets: ["APIProvider"]),
    ],
    dependencies: Dependencies.allCases.map(\.package),
    targets: [
        .target(name: "Models"),
        .target(
            name: "APIProvider",
            dependencies: [
                Dependencies.SwiftFP.target
            ]),
        .target(
            name: "Repository"),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
    ]
)

//MARK: - Dependencies
fileprivate enum Dependencies: CaseIterable {
    case SwiftUDF
    case SwiftFP
    case Realm
    
    var package: Package.Dependency {
        switch self {
        case .SwiftUDF: return .package(url: "https://github.com/ShapovalovIlya/SwiftUDF.git", branch: "main")
        case .SwiftFP: return .package(url: "https://github.com/ShapovalovIlya/SwiftFP.git", branch: "main")
        case .Realm: return .package(url: "https://github.com/realm/realm-swift.git", from: "10.42.3")
        }
    }
    
    var target: Target.Dependency {
        switch self {
        case .SwiftUDF: return .product(name: "SwiftUDF", package: "SwiftUDF")
        case .SwiftFP: return .product(name: "SwiftFP", package: "SwiftFP")
        case .Realm: return .product(name: "Realm-swift", package: "realm-swift")
        }
    }
}
