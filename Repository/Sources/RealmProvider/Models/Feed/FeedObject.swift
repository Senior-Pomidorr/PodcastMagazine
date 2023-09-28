//
//  FeedObject.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import RealmSwift
import Models

public final class FeedObject: Object, ObjectKeyIdentifiable {
    @Persisted public var id: Int
    @Persisted public var url: String
    @Persisted public var title: String
    @Persisted public var language: String
    @Persisted public var medium: Medium?
    @Persisted public var categories: List<CategoryObject>
    
    init(feed: Feed) {
        super.init()
        self.id = feed.id
        self.url = feed.url.absoluteString
        self.title = feed.title
        self.language = feed.language
        self.medium = feed.medium
        guard let categories = feed.categories else {
            return
        }
        self.categories = categories.reduce(into: self.categories, { partialResult, category in
            partialResult.append(.init(id: category.key, name: category.value))
        })
    }
    
    public override class func primaryKey() -> String? {
        "id"
    }
}

extension FeedObject: Encodable {
    //MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case language
        case medium
        case categories
    }
    
    //MARK: - encode(to:)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(medium, forKey: .medium)
        
        let encoded = categories.reduce(into: [String: String]()
        ) { partialResult, object in
            partialResult.updateValue(object.name, forKey: object.id)
        }
        try container.encode(encoded, forKey: .categories)
    }
}
