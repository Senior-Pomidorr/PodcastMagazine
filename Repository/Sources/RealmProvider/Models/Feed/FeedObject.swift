//
//  FeedObject.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import RealmSwift
import Models

final class FeedObject: Object, ObjectKeyIdentifiable {
    @Persisted var id: Int
    @Persisted var url: String
    @Persisted var title: String
    @Persisted var language: String
    @Persisted var medium: Medium?
    @Persisted var categories: List<CategoryObject>
    
    init(feed: Feed) {
        self.id = feed.id
        self.url = feed.url.absoluteString
        self.title = feed.title
        self.language = feed.language
        self.medium = feed.medium
    }
    
    override class func primaryKey() -> String? {
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
    func encode(to encoder: Encoder) throws {
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
