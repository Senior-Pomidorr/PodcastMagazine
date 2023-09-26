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
    
    public func perform<T: Decodable>(_ request: Repository.Request) -> AnyPublisher<Response<T>, Never> {
        switch request {
        case let .api(endpoint):
            apiManager.request(method: .GET, endpoint)
                .map(Response.success)
                .mapError(RepositoryError.init)
                .catch(Response.catchError(_:))
                .eraseToAnyPublisher()
        }
    }
    
}

public extension Repository {
    enum Request {
        case api(Endpoint)
    }
    
    enum Response<Wrapped> {
        case success(Wrapped)
        case error(RepositoryError)
        
        static func catchError(_ error: RepositoryError) -> Just<Self> {
            Just(.error(error))
        }
    }
    
}
