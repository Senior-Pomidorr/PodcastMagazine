// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Combine
import APIProvider
import RealmProvider
import FirebaseAuthProvider
import OSLog
import Models

/// Main facade for interaction with dependencies of API cals, Realm and Firebase.
public final class Repository {
    public typealias ResponsePublisher<T> = AnyPublisher<Response<T>, Never>
    
    /// Shared singleton Repository object
    static let shared = Repository()
    
    //MARK: - Private properties
    private let apiManager: APIManager
    private var realmManager: RealmManager?
    private let firebaseManager: FirebaseManager
    private let mainQueue: DispatchQueue = .main
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Repository.self)
    )
    
    //MARK: - init(_:)
    private init() {
        apiManager = .init(logger: logger)
        firebaseManager = .init()
        do {
            realmManager = try .init(config: .init(deleteRealmIfMigrationNeeded: true))
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    //MARK: - Public methods
    
    /// Универсальная функция для работы с репозиторием. Результатом ее работы является паблишер.
    /// Всегда публикует результат работы на главный поток.
    /// - Parameter endpoint: `Endpoint` модель предоставляющая  доступ к эндпоинтам для работы с сетью
    /// - Returns: Возвращает паблишер с перечислением `Response`
    func request<T: Decodable>(_ endpoint: Endpoint) -> ResponsePublisher<T> {
        apiManager.request(method: .GET, endpoint)
            .map(Response.success)
            .mapError(RepositoryError.init)
            .catch(Response.catchError(_:))
            .receive(on: mainQueue)
            .eraseToAnyPublisher()
    }
    
    func firebase(_ action: FirebaseManager.Action) -> ResponsePublisher<UserAccount> {
        firebaseManager.perform(action)
            .map(Response.success)
            .mapError(RepositoryError.init)
            .catch(Response.catchError)
            .eraseToAnyPublisher()
    }
    
    func firebaseLogout() -> ResponsePublisher<Void> {
        firebaseManager.logOut()
            .map(Response.success)
            .mapError(RepositoryError.init)
            .catch(Response.catchError)
            .eraseToAnyPublisher()
    }
    
    func firebaseResetPassword(_ email: String) -> ResponsePublisher<Void> {
        firebaseManager.changePassword(email: email)
            .map(Response.success)
            .mapError(RepositoryError.init)
            .catch(Response.catchError)
            .eraseToAnyPublisher()
    }
    
    func loadPersisted<T: Persistable>() -> AnyPublisher<[T], Never> {
        Just(realmManager?.values(T.self))
            .compactMap { $0 }
            .receive(on: mainQueue)
            .eraseToAnyPublisher()
    }
    
    func addPersisted<T: Persistable>(_ value: T) throws {
        try realmManager?.write {
            $0.add(value)
        }
    }
    
    func deletePersisted<T: Persistable>(_ value: T) throws {
        try realmManager?.write {
            $0.delete(value)
        }
    }
    
}

public extension Repository {
    /// Контейнер, отражающий результат работы репозитория..
    /// Тип `success` содержит запрашиваемую модель. `failure` хранит ошибку, возникшую во время работы.
    enum Response<Wrapped> {
        case success(Wrapped)
        case failure(RepositoryError)
        
        static func catchError(_ error: RepositoryError) -> Just<Self> {
            Just(.failure(error))
        }
    }
}

//struct ResponsePublisher<Value>: Publisher {
//    enum Response<Wrapped> {
//        case success(Wrapped)
//        case failure(Repository.RepositoryError)
//    }
//    
//    typealias Output = Response<Value>
//    typealias Failure = Never
//    
//    let output: Output
//    
//    //MARK: - init(_:)
//    init(output: Value) {
//        self.output = .success(output)
//    }
//    
//    init(error: Repository.RepositoryError) {
//        self.output = .failure(error)
//    }
//    
//    //MARK: - receive
//    func receive<S>(
//        subscriber: S
//    ) where S : Subscriber, Never == S.Failure, Response<Value> == S.Input {
//        subscriber.receive(output)
//    }
//    
//}
//
//extension ResponsePublisher {
//    class Subscription<Target: Subscriber>: Subscription {
//        var target: Target?
//        
//        func request(_ demand: Subscribers.Demand) {
//            
//        }
//        
//        func cancel() {
//            target = nil
//        }
//        
//    }
//}

