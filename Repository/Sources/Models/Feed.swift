//
//  Feed.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct Feed: Decodable, Identifiable {
    /// The internal PodcastIndex.org Feed ID.
    public let id: Int
    
    /// Current feed URL
    public let url: URL
    
    public let title: String
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec - https://www.rssboard.org/rss-language-codes
    public let language: String
    
    public let medium: Medium
    
    /// An array of categories, where the index is the Category ID and the value is the Category Name.
    public let categories: [Category]
    
    //MARK: - init(_:)
    public init(
        id: Int,
        url: URL,
        title: String,
        language: String,
        medium: Medium,
        categories: [Category]
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.language = language
        self.medium = medium
        self.categories = categories
    }
    
    //MARK: - CodingKeys
    enum CodingKeys: CodingKey {
        case feeds
        case id
        case url
        case title
        case language
        case medium
        case categories
    }
    
    //MARK: - init(from:)
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feeds)
        self.id = try nestedContainer.decode(Int.self, forKey: .id)
        self.url = try nestedContainer.decode(URL.self, forKey: .url)
        self.title = try nestedContainer.decode(String.self, forKey: .title)
        self.language = try nestedContainer.decode(String.self, forKey: .language)
        self.medium = try nestedContainer.decode(Medium.self, forKey: .medium)
        self.categories = try nestedContainer.decode([Category].self, forKey: .categories)
    }
    
    //MARK: - Sample
    public static let sample: Feed = .init(
        id: 75075,
        url: URL(string: "https://feeds.theincomparable.com/batmanuniversity")!,
        title: "Batman University",
        language: "en-us", 
        medium: .music,
        categories: [.sample]
    )
}
