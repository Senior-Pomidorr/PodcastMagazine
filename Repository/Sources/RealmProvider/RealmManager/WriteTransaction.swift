//
//  WriteTransaction.swift
//
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation
import RealmSwift

public struct WriteTransaction {
    private let realm: Realm
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    @discardableResult
    public func add<T: Persistable>(_ value: T) -> T {
        realm.add(value.managedObject(), update: .all)
        return value
    }
    
    @discardableResult
    public func delete<T: Persistable>(_ value: T) -> T {
        let results = realm.objects(T.ManagedObject.self)
        realm.delete(results)
        return value
    }
    
    @discardableResult
    public func update<T: Persistable>(_ value: T, properties: T.PropertyValue...) -> T {
        Logger.shared.logLevel(.debug, message: #function)
        let result = realm.create(
            T.ManagedObject.self,
            value: properties.map(\.propertyValuePair).reduce(into: [String: Any](), { $0[$1.name] = $1.value }),
            update: .modified
        )
        return T.init(result)
    }
    
}
