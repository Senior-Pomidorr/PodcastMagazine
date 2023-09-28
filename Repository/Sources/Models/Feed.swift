//
//  Feed.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct Feed: Decodable, Identifiable, Equatable {
    /// The internal PodcastIndex.org Feed ID.
    public let id: Int
    
    /// Current feed URL
    public let url: String
    
    /// Name of the feed
    public let title: String
    
    public let description: String
    
    /// The channel-level image element.
    public let image: String?
    
    /// The channel-level author element.
    public let author: String?
    
    /// The channel-level owner:name element.
    public let ownerName: String?
    
    /// The seemingly best artwork we can find for the feed.
    /// Might be the same as image in most instances.
    public let artwork: String?
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec - https://www.rssboard.org/rss-language-codes
    public let language: String
    
    public let medium: Medium?
    
    /// Number of episodes for this feed known to the index.
    public let episodeCount: Int?
    
    /// An array of categories, where the index is the Category ID and the value is the Category Name.
    public let categories: [String: String]?
    
    //MARK: - init(_:)
    public init(
        id: Int,
        url: String,
        title: String,
        description: String,
        image: String?,
        author: String?,
        ownerName: String?,
        artwork: String?,
        language: String,
        medium: Medium?,
        episodeCount: Int?,
        categories: [String : String]?
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.description = description
        self.image = image
        self.author = author
        self.ownerName = ownerName
        self.artwork = artwork
        self.language = language
        self.medium = medium
        self.episodeCount = episodeCount
        self.categories = categories
    }
    
    //MARK: - Sample
    public static let sample: Feed = .init(
        id: 75075,
        url: "https://feeds.theincomparable.com/batmanuniversity",
        title: "Batman University",
        description: "Batman University is a seasonal podcast about you know who. It began with an analysis of episodes of “Batman: The Animated Series” but has now expanded to cover other series, movies, and media. Your professor is Tony Sindelar.",
        image: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11",
        author: "Tony Sindelar",
        ownerName: "The Incomparable",
        artwork: "https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11",
        language: "en-us",
        medium: .music,
        episodeCount: 19,
        categories: [
            "104": "Tv",
            "105": "Film",
            "107": "Reviews"
        ]
    )
}
