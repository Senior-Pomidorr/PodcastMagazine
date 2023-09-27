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
    
    
}
