//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift
import Models

final class EpisodeObject: Object, ObjectKeyIdentifiable {
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var episodeDescription: String
    @Persisted var guid: String
    @Persisted var datePublished: Int
    @Persisted var datePublishedPretty: String
    @Persisted var dateCrawled: Int
    @Persisted var enclosureUrl: String
    @Persisted var explicit: Int
    @Persisted var episode: Int?
    @Persisted var episodeType: Episode.EpisodeType?
    @Persisted var season: Int?
    @Persisted var image: String
    @Persisted var feedImage: String
    @Persisted var feedId: Int
    @Persisted var feedTitle: String
    @Persisted var feedLanguage: String
    @Persisted var chaptersUrl: String?
    
    init(episode: Episode) {
        super.init()
        self.id = episode.id
        self.title = episode.title
        self.link = episode.link.absoluteString
        self.episodeDescription = episode.description
        self.guid = episode.guid
        self.datePublished = episode.datePublished
        self.datePublishedPretty = episode.datePublishedPretty
        self.dateCrawled = episode.dateCrawled
        self.enclosureUrl = episode.enclosureUrl.absoluteString
        self.explicit = episode.explicit
        self.episode = episode.episode
        self.episodeType = episode.episodeType
        self.season = episode.season
        self.image = episode.image.absoluteString
        self.feedImage = episode.feedImage.absoluteString
        self.feedId = episode.feedId
        self.feedTitle = episode.feedTitle
        self.feedLanguage = episode.feedLanguage
        self.chaptersUrl = episode.chaptersUrl?.absoluteString
    }
    
    override class func primaryKey() -> String? {
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
