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
    
    func add<T: Persistable>(_ value: T, update: Realm.UpdatePolicy) {
        realm.add(value.managedObject(), update: update)
    }
    
    func update<T: Persistable>(_ type: T.Type, values: [T.PropertyValue]) {
        realm.create(
            T.ManagedObject.self,
            value: values.map(\.propertyValuePair).reduce(into: [String: Any](), { $0[$1.name] = $1.value }),
            update: .modified
        )
    }
    
}
