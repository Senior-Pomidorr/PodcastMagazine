//
//  Feed.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models
import RealmSwift

extension Feed: Persistable {
    init(_ managedObject: FeedObject) throws {
        guard let url = URL(string: managedObject.url) else {
            throw RealmError.missingValue
        }
        
        let categories = managedObject.categories
            .reduce(into: [String: String]()
            ) { partialResult, object in
                partialResult.updateValue(object.name, forKey: object.id)
            }
        self.init(
            id: managedObject.id,
            url: url,
            title: managedObject.title,
            language: managedObject.language,
            medium:  managedObject.medium,
            categories: categories
        )
    }
    
    func managedObject() -> FeedObject {
        FeedObject(feed: self)
    }
}
