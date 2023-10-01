//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift
import Models

public final class EpisodeObject: Object, ObjectKeyIdentifiable {
    @Persisted public var id: Int
    @Persisted public var title: String
    @Persisted public var link: String
    @Persisted public var episodeDescription: String
    @Persisted public var guid: String
    @Persisted public var datePublished: Int
    @Persisted public var datePublishedPretty: String
    @Persisted public var dateCrawled: Int
    @Persisted public var enclosureUrl: String
    @Persisted public var explicit: Int
    @Persisted public var episode: Int?
    @Persisted public var episodeType: Episode.EpisodeType?
    @Persisted public var season: Int?
    @Persisted public var image: String
    @Persisted public var feedImage: String
    @Persisted public var feedId: Int
    @Persisted public var feedTitle: String
    @Persisted public var feedLanguage: String
    @Persisted public var chaptersUrl: String?
    
    convenience init(episode: Episode) {
        self.init()
        self.id = episode.id
        self.title = episode.title
        self.link = episode.link
        self.episodeDescription = episode.description
        self.guid = episode.guid
        self.datePublished = episode.datePublished
        self.datePublishedPretty = episode.datePublishedPretty
        self.dateCrawled = episode.dateCrawled
        self.enclosureUrl = episode.enclosureUrl
        self.explicit = episode.explicit
        self.episode = episode.episode
        self.episodeType = episode.episodeType
        self.season = episode.season
        self.image = episode.image
        self.feedImage = episode.feedImage
        self.feedId = episode.feedId
        self.feedTitle = episode.feedTitle
        self.feedLanguage = episode.feedLanguage
        self.chaptersUrl = episode.chaptersUrl
    }
    
    public override class func primaryKey() -> String? {
        "id"
    }
}

extension Episode.EpisodeType: PersistableEnum {
    public static var allCases: [Episode.EpisodeType] {
        var arr = [Episode.EpisodeType]()
        arr.append(.bonus)
        arr.append(.full)
        arr.append(.trailer)
        return arr
    }
}
