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
    
    func add<T: Persistable>(_ value: T) {
        realm.add(value.managedObject(), update: .all)
    }
    
}
