// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Combine
import APIProvider
import RealmProvider
import FirebaseAuthProvider
import OSLog

/// Main facade for interaction with dependencies of API cals, Realm and Firebase.
public final class Repository {
    public typealias ResponsePublisher<T> = AnyPublisher<Response<T>, Never>
    
    /// Shared singleton Repository object
    static let shared = Repository()
    
    //MARK: - Private properties
    private let apiManager: APIManager
    private let realmManager: RealmManager
    private let mainQueue: DispatchQueue = .main
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Repository.self)
    )
    
    //MARK: - init(_:)
    private init() {
        apiManager = .init(logger: logger)
        realmManager = try! .init(logger: .shared)
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
    
    
    func loadPersisted<T: Persistable>() -> Just<[T]> {
        Just(realmManager.values(T.self))
    }
    
    
    func writeToDatabase<T: Persistable>(_ block: @escaping (WriteTransaction) -> T) throws {
        try realmManager.write(block)
    }
    
    public static func configure() {
        FirebaseProvider.configure()
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
