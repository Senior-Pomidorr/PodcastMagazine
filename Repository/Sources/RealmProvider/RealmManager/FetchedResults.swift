//
//  FetchedResults.swift
//
//
//  Created by Илья Шаповалов on 28.09.2023.
//

import Foundation
import RealmSwift

@dynamicMemberLookup
struct FetchedResults<T: Persistable> {
    let results: [T]
    
    init(_ results: Results<T.ManagedObject>) throws {
        self.results = try results.map(T.init(_:))
    }
    
    subscript<V>(dynamicMember keyPath: WritableKeyPath<[T], V>) -> V {
        results[keyPath: keyPath]
    }
    
}
