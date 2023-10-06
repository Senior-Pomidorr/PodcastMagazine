//
//  CategoryObject.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift

public final class CategoryObject: Object, ObjectKeyIdentifiable {
    @Persisted public var id: String
    @Persisted public var name: String
    
    convenience init(id: String, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
}
