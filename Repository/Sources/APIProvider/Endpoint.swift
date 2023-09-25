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
        queryItems: [URLQueryItem] = .init()
    ) {
        self.path = path
        self.queryItems = queryItems
    }
    
    //MARK: - Endpoints
    
    /// Return all the possible categories supported by the index. Return `CategoryResponse` model.
    public static let categories = Self(path: "categories/list")
    
    /// This call returns all the episodes we know about for this feed from the PodcastIndex ID. Episodes are in reverse chronological order.
    /// - Parameters:
    ///   - feedId: The internal PodcastIndex.org Feed ID.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `EpisodesResponse` model
    public static func episodes(
        by feedId: Int,
        max: Int = 20
    ) -> Self {
        .init(
            path: "episodes/byfeedid",
            queryItems: [
                .init(name: "id", value: feedId.description),
                .init(name: "max", value: max.description)
            ])
    }
    
    /// This call returns the most recent max feeds, in reverse chronological order.
    /// - Parameters:
    ///   - category: `Category` model
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedResponse` model
    public static func recentFeeds(
        by category: Models.Category,
        max: Int = 20
    ) -> Self {
        .init(
            path: "recent/feeds",
            queryItems: [
                .init(name: "cat", value: category.name),
                .init(name: "max", value: max.description)
            ])
    }
    
    /// This call returns the podcasts/feeds that in the index that are trending.
    /// - Parameter max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedResponse` model
    public static func trendingFeeds(max: Int = 20) -> Self {
        .init(
            path: "podcasts/trending",
            queryItems: [
                .init(name: "max", value: max.description)
            ])
    }
    
    /// This call returns the most recent max feeds, in reverse chronological order.
    /// - Parameter max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedResponse` model
    public static func recentFeeds(max: Int = 20) -> Self {
        .init(
            path: "recent/feeds",
            queryItems: [
                .init(name: "max", value: max.description)
            ])
    }
    
    /// This call returns all feeds marked with the specified medium tag value.
    /// - Parameters:
    ///   - medium: The medium value to search for.
    ///   - max: Maximum number of results to return.
    /// - Returns: Call to this endpoint return `FeedResponse` model
    public static func feeds(
        by medium: Medium,
        max: Int = 20
    ) -> Self {
        .init(
            path: "podcasts/bymedium",
            queryItems: [
                .init(name: "medium", value: medium.rawValue),
                .init(name: "max", value: max.description)
            ])
    }
    
    
}
