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
        case url(String)
        case title(String)
        case description(String)
        case image(String)
        case author(String)
        case ownerName(String)
        case artwork(String)
        case language(String)
        case medium(Medium)
        case episodeCount(Int)
        case categories([String: String])
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case let .id(id):                   return ("id", id)
            case let .url(url):                 return ("url", url)
            case let .title(title):             return ("title", title)
            case let .language(language):       return ("language", language)
            case let .medium(medium):           return ("medium", medium)
            case let .categories(categories):   return ("categories", categories.map(CategoryObject.init(id:name:)))
            case let .description(description): return ("description", description)
            case let .image(url):               return ("image", url)
            case let .author(author):           return ("author", author)
            case let .ownerName(name):          return ("ownerName", name)
            case let .artwork(url):             return ("artwork", url)
            case let .episodeCount(count):      return ("episodeCount", count)
            }
        }
    }
    
    //MARK: - init(managedObject:)
    public init(_ managedObject: FeedObject) {
        let categories = managedObject.categories
            .reduce(into: [String: String]()
            ) { partialResult, object in
                partialResult.updateValue(object.name, forKey: object.id)
            }
        self.init(
            id: managedObject.id,
            url: managedObject.url,
            title: managedObject.title,
            description: managedObject.feedDescription,
            image: managedObject.image,
            author: managedObject.author,
            ownerName: managedObject.ownerName,
            artwork: managedObject.artwork,
            language: managedObject.language,
            medium: managedObject.medium,
            episodeCount: managedObject.episodeCount,
            categories: categories
        )
    }
    
    public func managedObject() -> FeedObject {
        FeedObject(feed: self)
    }
}
