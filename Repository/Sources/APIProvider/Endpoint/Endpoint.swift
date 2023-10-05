//
//  Endpoint.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation
import Models

public struct Endpoint {
    private let path: String
    private let queryItems: [URLQueryItem]
    
    //MARK: - URL
    public var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.podcastindex.org"
        components.path = ["/api/1.0/", path].joined()
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            preconditionFailure("Unable to create url from: \(components)")
        }
        return url
    }
    
    //MARK: - init(_:)
    private init(
        path: String,
        @QueryBuilder queryBuilder: () -> [URLQueryItem]
    ) {
        self.path = path
        self.queryItems = queryBuilder()
    }
    
    //MARK: - Endpoints
    
    /// Return all the possible categories supported by the index. Return `CategoryResponse` model.
    public static let categories = Self(path: "categories/list") {}
    
    /// This call returns a random batch of episodes, in no specific order.
    /// - Parameter max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `EpisodesResponse` model
    public static func randomEpisodes(
        by category: Models.Category? = nil,
        max: Int = 20
    ) -> Self {
        .init(path: "episodes/random") {
            if let category = category {
                URLQueryItem(name: "cat", value: category.name)
            }
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns all the episodes we know about for this feed from the PodcastIndex ID. Episodes are in reverse chronological order.
    /// - Parameters:
    ///   - feedId: The internal PodcastIndex.org Feed ID.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `EpisodesResponse` model
    public static func episodes(
        by feedId: Int,
        max: Int = 20
    ) -> Self {
        .init(path: "episodes/byfeedid") {
            URLQueryItem(name: "id", value: feedId.description)
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns all of the episodes where the specified person is mentioned.
    /// It searches the following fields: `Person tags`, `Episode title`, `Episode description`, `Feed owner`,
    /// `Feed author`
    /// - Parameters:
    ///   - person: Person search for
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `EpisodesResponse` model
    public static func episodes(
        by person: String,
        max: Int = 20
    ) -> Self {
        .init(path: "search/byperson") {
            URLQueryItem(name: "q", value: person)
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns the most recent max feeds, in reverse chronological order.
    /// - Parameters:
    ///   - category: `Category` model
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func recentFeeds(
        by category: Models.Category,
        max: Int = 20
    ) -> Self {
        .init(path: "recent/feeds") {
            URLQueryItem(name: "cat", value: category.name)
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns the podcasts/feeds that in the index that are trending.
    /// - Parameter max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func trendingFeeds(max: Int = 20) -> Self {
        .init(path: "podcasts/trending") {
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns the most recent max feeds, in reverse chronological order.
    /// - Parameter max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func recentFeeds(max: Int = 20) -> Self {
        .init(path: "recent/feeds") {
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns all feeds marked with the specified medium tag value.
    /// - Parameters:
    ///   - medium: The medium value to search for.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func feeds(
        by medium: Medium,
        max: Int = 20
    ) -> Self {
        .init(path: "podcasts/bymedium") {
            URLQueryItem(name: "medium", value: medium.rawValue)
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    
    /// This call returns everything we know about the feed from the PodcastIndex ID
    /// - Parameter feedId: The PodcastIndex Feed ID
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func feeds(
        by feedId: Int
    ) -> Self {
        .init(path: "podcasts/byfeedid") {
            URLQueryItem(name: "id", value: feedId.description)
        }
    }
    
    /// This call returns all of the feeds where the title of the feed matches the search term (ignores case).
    /// - Parameters:
    ///   - title: Terms to search for. Example "everything everywhere daily" will match the podcast Everything Everywhere Daily by "everything everywhere" will not.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func feeds(
        byTitle title: String,
        max: Int = 20
    ) -> Self {
        .init(path: "search/bytitle") {
            URLQueryItem(name: "q", value: title.replacingOccurrences(of: " ", with: "+"))
            URLQueryItem(name: "similar", value: true.description)
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
    /// This call returns all of the feeds that match the search terms in the title, author or owner of the feed.
    /// - Parameters:
    ///   - term: Terms to search for. Example "everything everywhere daily" will match the podcast Everything Everywhere Daily by "everything everywhere" will not.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedsResponse` model
    public static func feeds(
        byTerm term: String,
        max: Int = 20
    ) -> Self {
        .init(path: "search/byterm") {
            URLQueryItem(name: "q", value: term.replacingOccurrences(of: " ", with: "+"))
            URLQueryItem(name: "max", value: max.description)
        }
    }
    
}
