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
    public init(
        config: Realm.Configuration = .defaultConfiguration,
        logger: Logger? = nil
    ) throws {
        self.realm = try Realm(configuration: config)
        guard let logger = logger else { return }
        Logger.shared = logger
    }
    
    //MARK: - Public methods
    public func write<T: Persistable>(_ block: @escaping (WriteTransaction) -> T) throws {
        Logger.shared.logLevel(.debug, message: #function)
        try realm.write {
            block(WriteTransaction(realm: realm))
        }
    }
    
    public func values<T: Persistable>(_ type: T.Type) -> [T] {
        Logger.shared.logLevel(.debug, message: #function)
        return realm.objects(type.ManagedObject.self)
            .map(T.init)
    }
    
    public func values<T: Persistable>(
        _ type: T.Type,
        isIncluded: @escaping (Query<T.ManagedObject>) -> Query<Bool>
    ) -> [T] {
        Logger.shared.logLevel(.debug, message: #function)
        return realm.objects(type.ManagedObject.self)
            .where(isIncluded)
            .map(T.init)
    }
}
