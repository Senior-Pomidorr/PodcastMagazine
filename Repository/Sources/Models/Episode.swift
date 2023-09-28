//
//  Episode.swift
//
//
//  Created by Илья Шаповалов on 24.09.2023.
//

import Foundation

public struct Episode: Identifiable, Decodable, Equatable {
    /// The internal PodcastIndex.org episode ID.
    public let id: Int
    
    public let title: String
    
    /// The channel-level link in the feed
    public let link: String
    
    public let description: String
    
    /// The unique identifier for the episode
    public let guid: String
    
    /// The date and time the episode was published
    public let datePublished: Int
    
    /// The date and time the episode was published formatted as a human readable string.
    public let datePublishedPretty: String
    
    /// The time this episode was found in the feed
    public let dateCrawled: Int
    
    /// URL/link to the episode file
    public let enclosureUrl: String
    
    /// Is feed or episode marked as explicit. 0 - not marked explicit, 1 - marked explicit.
    public let explicit: Int
    
    public let episode: Int?
    
    public let episodeType: EpisodeType?
    
    public let season: Int?
    
    /// The item-level image for the episode
    public let image: String
    
    /// The item-level image for the episode
    public let feedImage: String
    
    /// The internal PodcastIndex.org Feed ID.
    public let feedId: Int
    
    public let feedTitle: String
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec - https://www.rssboard.org/rss-language-codes
    public let feedLanguage: String
    
    /// Link to the JSON file containing the episode chapters
    public let chaptersUrl: String?
    
    //MARK: - init(_:)
    public init(
        id: Int,
        title: String,
        link: String,
        description: String,
        guid: String,
        datePublished: Int,
        datePublishedPretty: String,
        dateCrawled: Int,
        enclosureUrl: String,
        explicit: Int,
        episode: Int?,
        episodeType: EpisodeType?,
        season: Int?,
        image: String,
        feedImage: String,
        feedId: Int,
        feedTitle: String,
        feedLanguage: String,
        chaptersUrl: String?
    ) {
        self.id = id
        self.title = title
        self.link = link
        self.description = description
        self.guid = guid
        self.datePublished = datePublished
        self.datePublishedPretty = datePublishedPretty
        self.dateCrawled = dateCrawled
        self.enclosureUrl = enclosureUrl
        self.explicit = explicit
        self.episode = episode
        self.episodeType = episodeType
        self.season = season
        self.image = image
        self.feedImage = feedImage
        self.feedId = feedId
        self.feedTitle = feedTitle
        self.feedLanguage = feedLanguage
        self.chaptersUrl = chaptersUrl
    }
}

public extension Episode {
    enum EpisodeType: String, Decodable {
        case full
        case trailer
        case bonus
    }
    
    static let sample: Episode = .init(
        id: 16795088,
        title: "Batman University",
        link: "https://www.theincomparable.com/batmanuniversity/",
        description: "Batman University is back in session! James Thomson and Nathan Alderman join Tony for a discussion of Fox’s “Gotham.” Tune in to hear our thoughts on how a half-baked comic book show was reborn into an unmissable train wreck.",
        guid: "incomparable/batman/19",
        datePublished: 1546399813, 
        datePublishedPretty: "January 01, 2019 9:30pm",
        dateCrawled: 1598369047,
        enclosureUrl: "https://www.theincomparable.com/podcast/batmanuniversity302.mp3",
        explicit: 0,
        episode: 19,
        episodeType: .full,
        season: 3, 
        image: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11",
        feedImage: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11",
        feedId: 75075,
        feedTitle: "Batman University",
        feedLanguage: "en-us",
        chaptersUrl: nil
    )
}
