//
//  RealmManager.swift
//  
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation
import RealmSwift
import Combine

public struct RealmManager {
    private let realm: Realm
    
    //MARK: - init(_:)
    public init() throws {
        try self.init(realm: Realm())
    }
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    //MARK: - Public methods
    public func write(_ block: (WriteTransaction) throws -> Void) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
        
    }
    
    public func update<T: Persistable>(values: T.PropertyValue...) -> AnyPublisher<T, RealmError> {
        Deferred {
            Future { promise in
                let result = realm.create(
                    T.ManagedObject.self,
                    value: values.map(\.propertyValuePair).reduce(into: [String: Any](), { $0[$1.name] = $1.value }),
                    update: .modified
                )
                do {
                    let model = try T.init(result)
                    promise(.success(model))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .mapError(RealmError.map(_:))
        .eraseToAnyPublisher()
    }
    
    func values<T: Persistable>(_ type: T.Type, isIncluded: @escaping (Query<T.ManagedObject>) -> Query<Bool>) -> AnyPublisher<[T], RealmError> {
        Deferred { [isIncluded] in
            Future { promise in
                do {
                    let results = try realm.objects(type.ManagedObject.self)
                        .where(isIncluded)
                        .map(T.init(_:))
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .mapError(RealmError.map(_:))
        .eraseToAnyPublisher()
    }
}
