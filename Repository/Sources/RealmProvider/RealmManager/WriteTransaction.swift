//
//  WriteTransaction.swift
//
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation
import RealmSwift

public struct WriteTransaction<T: Persistable> {
    private let realm: Realm
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    public func add(_ value: T) {
        realm.add(value.managedObject(), update: .all)
    }
    
    public func delete(_ value: T) {
        let objectId = value.managedObject().id
        let results = realm.objects(T.ManagedObject.self).where({ $0.id == objectId })
        realm.delete(results)
    }
    
    @discardableResult
    public func update(_ value: T, properties: T.PropertyValue...) -> T {
        Logger.shared.logLevel(.debug, message: #function)
        let result = realm.create(
            T.ManagedObject.self,
            value: properties.map(\.propertyValuePair).reduce(into: [String: Any](), { $0[$1.name] = $1.value }),
            update: .modified
        )
        return T.init(result)
    }
    
}
