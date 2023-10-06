// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
    ],
    products: [
        .library(name: "Repository", targets: ["Repository"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "LoadableImage", targets: ["LoadableImage"]),
        .library(name: "RootDomain", targets: ["RootDomain"]),
        .library(name: "AuthorizationDomain", targets: ["AuthorizationDomain"])
//        .library(name: "SignInWithGoogle", targets: ["SignInWithGoogle"]),
    ],
    dependencies: Dependencies.allCases.map(\.package),
    targets: [
        .target(name: "Models"),
        .target(
            name: "APIProvider",
            dependencies: [
                "Models",
                Dependencies.SwiftFP.target,
            ]),
        .target(
            name: "RealmProvider",
            dependencies: [
                Dependencies.Realm.target,
                "Models",
            ]),
        .target(
            name: "FirebaseAuthProvider",
            dependencies: [
                Dependencies.FirebaseAuth.target,
                Dependencies.FirebaseAuth.firebaseAuthCombine
            ]),
        .target(name: "LoadableImage"),
        .target(
            name: "Repository",
            dependencies: [
                Dependencies.FirebaseAuth.target,
                Dependencies.GoogleSignIn.target,
                "APIProvider",
                "RealmProvider",
                "FirebaseAuthProvider",
            ]),
        .target(
            name: "AuthorizationDomain",
            dependencies: [
                "Repository",
                "Models",
                Dependencies.SwiftUDF.target,
            ]),
        .target(
            name: "RootDomain",
            dependencies: [
                "Repository",
                "Models",
                "AuthorizationDomain",
                Dependencies.SwiftUDF.target,
            ]),
//        .testTarget(
//            name: "SignInWithGoogle",
//            dependencies: [
//                Dependencies.GoogleSignIn.target,
//                "Repository"
//            ]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "Repository",
                "APIProvider",
                "Models",
                "RealmProvider",
                "RootDomain",
                "AuthorizationDomain"
            ]),
    ]
)

//MARK: - Dependencies
fileprivate enum Dependencies: CaseIterable {
    case SwiftFP
    case SwiftUDF
    case Realm
    case FirebaseAuth
    case GoogleSignIn
    
    var package: Package.Dependency {
        switch self {
        case .SwiftFP: return .package(url: "https://github.com/ShapovalovIlya/SwiftFP.git", branch: "main")
        case .Realm: return .package(url: "https://github.com/realm/realm-swift.git", from: "10.43.0")
        case .FirebaseAuth:
            return .package(
                url: "https://github.com/firebase/firebase-ios-sdk",
                .upToNextMajor(from: "10.15.0"))
        case .GoogleSignIn: return .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0")
        case .SwiftUDF: return .package(url: "https://github.com/ShapovalovIlya/SwiftUDF.git", branch: "main")
        }
    }
    
    var target: Target.Dependency {
        switch self {
        case .FirebaseAuth: return .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
        case .SwiftFP: return .product(name: "SwiftFP", package: "SwiftFP")
        case .Realm: return .product(name: "RealmSwift", package: "realm-swift")
        case .GoogleSignIn: return .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
        case .SwiftUDF: return .product(name: "SwiftUDF", package: "SwiftUDF")
        }
    }
    
    var firebaseAuthCombine: Target.Dependency {
        .product(name: "FirebaseAuthCombine-Community", package: "firebase-ios-sdk")
    }
}

fileprivate enum Firebase {
    case Auth
    case AuthCombine
    case Storage
    
    var target: Target.Dependency {
        switch self {
        case .Auth: return .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
        case .AuthCombine: return .product(name: "FirebaseAuthCombine-Community", package: "firebase-ios-sdk")
        case .Storage: return .product(name: "Firestore", package: "firebase-ios-sdk")
        }
    }
    
    static let package: Package.Dependency = .package(
        url: "https://github.com/firebase/firebase-ios-sdk",
        .upToNextMajor(from: "10.15.0"))
}
