//
//  CategoryObject.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift

final class CategoryObject: Object, ObjectKeyIdentifiable {
    @Persisted var id: String
    @Persisted var name: String
    
    init(id: String, name: String) {
        super.init()
        self.id = id
        self.name = name
    }
}
