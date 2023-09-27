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
    public let url: URL
    
    public let title: String
    
    /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec - https://www.rssboard.org/rss-language-codes
    public let language: String
    
    public let medium: Medium?
    
    /// An array of categories, where the index is the Category ID and the value is the Category Name.
    public let categories: [String: String]
    
    //MARK: - init(_:)
    public init(
        id: Int,
        url: URL,
        title: String,
        language: String,
        medium: Medium?,
        categories: [String: String]
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.language = language
        self.medium = medium
        self.categories = categories
    }
    
    //MARK: - Sample
    public static let sample: Feed = .init(
        id: 75075,
        url: URL(string: "https://feeds.theincomparable.com/batmanuniversity")!,
        title: "Batman University",
        language: "en-us", 
        medium: .music,
        categories: [:]
    )
}
