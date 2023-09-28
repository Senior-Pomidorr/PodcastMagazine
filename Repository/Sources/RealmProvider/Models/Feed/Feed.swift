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
    public typealias ManagedObject = FeedObject
    
    //MARK: - PropertyValue
    public enum PropertyValue: PropertyValueType {
        case id(Int)
        case url(URL)
        case title(String)
        case language(String)
        case medium(Medium)
        case categories([String: String])
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case let .id(id):                 return ("id", id)
            case let .url(url):               return ("url", url)
            case let .title(title):           return ("title", title)
            case let .language(language):     return ("language", language)
            case let .medium(medium):         return ("medium", medium)
            case let .categories(categories): return ("categories", categories.map(CategoryObject.init))
            }
        }
    }
    
    //MARK: - init(managedObject:)
    public init(_ managedObject: FeedObject) throws {
        guard let url = URL(string: managedObject.url) else {
            throw RealmManager.RealmError.missingValue
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
    
    public func managedObject() -> FeedObject {
        FeedObject(feed: self)
    }
}
