//
//  RealmFeed.swift
//
//
//  Created by Илья Шаповалов on 26.09.2023.
//

import Foundation
import RealmSwift
import Models

final class RealmFeed: Object, ObjectKeyIdentifiable {
    @Persisted var id: Int
    @Persisted var url: String
    @Persisted var title: String
    @Persisted var language: String
    @Persisted var medium: Medium.RawValue?
//    @Persisted var categories: [Models.Category]
    
    init(feed: Feed) {
        self.id = feed.id
        self.url = feed.url.absoluteString
        self.title = feed.title
        self.language = feed.language
        self.medium = feed.medium?.rawValue
    }
}
