// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Combine
import APIProvider
import RealmProvider
import FirebaseAuthProvider

public struct Repository {
    
    //MARK: - Private properties
    private let apiManager: APIManager
    
    //MARK: - init(_:)
    public init() {
        apiManager = .init()
    }
    
}

public extension Repository {
    enum Request {
        
    }
    
    enum Response {
        case success
        case error(RepositoryError)
    }
    
    enum RepositoryError {
        
    }
}
