// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Combine
import APIProvider
import RealmProvider
import FirebaseAuthProvider
import OSLog

/// Псевдоним, описывающий взаимодействие с репозиторием.
/// Для корректного использование, нужно явно указать тип возвращаемого значения.
///
///     let trendingFeedRequest: RepositoryRequest<[Feed]> = Repository.shared.perform(request:)
///
public typealias RepositoryRequest<T> = (Repository.Request) -> Repository.ResponsePublisher<T>

/// Main facade for interaction with dependencies of API cals, Realm and Firebase.
public final class Repository {
    public typealias ResponsePublisher<T> = AnyPublisher<Response<T>, Never>
    
    /// Shared singleton Repository object
    static let shared = Repository()
    
    //MARK: - Private properties
    private let apiManager: APIManager
    private let mainQueue: DispatchQueue = .main
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Repository.self)
    )
    
    //MARK: - init(_:)
    private init() {
        apiManager = .init(logger: logger)
    }
    
    //MARK: - Public methods
    
    /// Универсальная функция для работы с репозиторием. Результатом ее работы является паблишер.
    /// Всегда публикует результат работы на главный поток.
    /// - Parameter request: `Request`перечисление, предоставляющее доступ к эндпоинтам для работы с сетью, базой данных или Firebase.
    /// - Returns: Возвращает паблишер с перечислением `Response`
    func perform<T: Decodable>(request: Repository.Request) -> ResponsePublisher<T> {
        switch request {
        case let .api(endpoint):
            apiManager.request(method: .GET, endpoint)
                .map(Response.success)
                .mapError(RepositoryError.init)
                .catch(Response.catchError(_:))
                .receive(on: mainQueue)
                .eraseToAnyPublisher()
        }
    }
    
}

public extension Repository {
    /// Перечисление для эндпоинтов сетевых вызовов, работы с базой данных или Firebase.
    enum Request {
        case api(Endpoint)
    }
    
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
