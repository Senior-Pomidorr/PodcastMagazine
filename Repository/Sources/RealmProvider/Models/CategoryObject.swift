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
    @Persisted var name: String
    
    init(id: String, name: String) {
        super.init()
        self.id = id
        self.name = name
    }
}
