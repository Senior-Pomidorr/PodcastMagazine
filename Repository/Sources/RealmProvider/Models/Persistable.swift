//
//  Persistable.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    
    init(_ managedObject: ManagedObject)
    
    func managedObject() -> ManagedObject
}
