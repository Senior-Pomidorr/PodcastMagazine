//
//  Episode.swift
//
//
//  Created by Илья Шаповалов on 24.09.2023.
//

import Foundation

public struct Episode: Identifiable, Decodable {
    /// The internal PodcastIndex.org episode ID.
    public let id: Int
    
    public let title: String
    
    /// The channel-level link in the feed
    public let link: URL
    
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
    public let enclosureUrl: URL
    
    /// Is feed or episode marked as explicit. 0 - not marked explicit, 1 - marked explicit.
    public let explicit: Int
    
    public let episode: Int?
    
    public let episodeType: EpisodeType?
    
    public let season: Int?
    
    /// The item-level image for the episode
    public let image: URL
    
    /// The item-level image for the episode
    public let feedImage: URL
    
    /// The internal PodcastIndex.org Feed ID.
    public let feedId: Int
    
    public let feedTitle: String
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec - https://www.rssboard.org/rss-language-codes
    public let feedLanguage: String
    
    /// Link to the JSON file containing the episode chapters
    public let chaptersUrl: URL?
    
    //MARK: - init(_:)
    public init(
        id: Int,
        title: String,
        link: URL,
        description: String,
        guid: String,
        datePublished: Int,
        datePublishedPretty: String,
        dateCrawled: Int,
        enclosureUrl: URL,
        explicit: Int,
        episode: Int?,
        episodeType: EpisodeType?,
        season: Int?,
        image: URL,
        feedImage: URL,
        feedId: Int,
        feedTitle: String,
        feedLanguage: String,
        chaptersUrl: URL?
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
    
    //MARK: - Coding keys
    enum CodingKeys: CodingKey {
        case items
        case id
        case title
        case link
        case description
        case guid
        case datePublished
        case datePublishedPretty
        case dateCrawled
        case enclosureUrl
        case explicit
        case episode
        case episodeType
        case season
        case image
        case feedImage
        case feedId
        case feedTitle
        case feedLanguage
        case chaptersUrl
    }
    
    //MARK: - init(from:)
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .items)
        self.id = try nestedContainer.decode(Int.self, forKey: .id)
        self.title = try nestedContainer.decode(String.self, forKey: .title)
        self.link = try nestedContainer.decode(URL.self, forKey: .link)
        self.description = try nestedContainer.decode(String.self, forKey: .description)
        self.guid = try nestedContainer.decode(String.self, forKey: .guid)
        self.datePublished = try nestedContainer.decode(Int.self, forKey: .datePublished)
        self.datePublishedPretty = try nestedContainer.decode(String.self, forKey: .datePublishedPretty)
        self.dateCrawled = try nestedContainer.decode(Int.self, forKey: .dateCrawled)
        self.enclosureUrl = try nestedContainer.decode(URL.self, forKey: .enclosureUrl)
        self.explicit = try nestedContainer.decode(Int.self, forKey: .explicit)
        self.episode = try nestedContainer.decodeIfPresent(Int.self, forKey: .episode)
        self.episodeType = try nestedContainer.decodeIfPresent(Episode.EpisodeType.self, forKey: .episodeType)
        self.season = try nestedContainer.decodeIfPresent(Int.self, forKey: .season)
        self.image = try nestedContainer.decode(URL.self, forKey: .image)
        self.feedImage = try nestedContainer.decode(URL.self, forKey: .feedImage)
        self.feedId = try nestedContainer.decode(Int.self, forKey: .feedId)
        self.feedTitle = try nestedContainer.decode(String.self, forKey: .feedTitle)
        self.feedLanguage = try nestedContainer.decode(String.self, forKey: .feedLanguage)
        self.chaptersUrl = try nestedContainer.decodeIfPresent(URL.self, forKey: .chaptersUrl)
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
        link: URL(string: "https://www.theincomparable.com/batmanuniversity/")!,
        description: "Batman University is back in session! James Thomson and Nathan Alderman join Tony for a discussion of Fox’s “Gotham.” Tune in to hear our thoughts on how a half-baked comic book show was reborn into an unmissable train wreck.",
        guid: "incomparable/batman/19",
        datePublished: 1546399813, 
        datePublishedPretty: "January 01, 2019 9:30pm",
        dateCrawled: 1598369047,
        enclosureUrl: URL(string: "https://www.theincomparable.com/podcast/batmanuniversity302.mp3")!,
        explicit: 0,
        episode: 19,
        episodeType: .full,
        season: 3, 
        image: URL(string: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11")!,
        feedImage: URL(string: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11")!,
        feedId: 75075,
        feedTitle: "Batman University",
        feedLanguage: "en-us",
        chaptersUrl: nil
    )
}
