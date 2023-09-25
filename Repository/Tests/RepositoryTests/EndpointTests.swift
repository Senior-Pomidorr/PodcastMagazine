//
//  EndpointTests.swift
//  
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import XCTest
import APIProvider
import Models

final class EndpointTests: XCTestCase {
    func test_categories() {
        XCTAssertEqual(
            Endpoint.categories.url,
            URL(string: "https://api.podcastindex.org/api/1.0/categories/list")
        )
    }
    
    func test_episodest() {
        XCTAssertEqual(
            Endpoint.episodes(by: 75075).url,
            URL(string: "https://api.podcastindex.org/api/1.0/episodes/byfeedid?id=75075&max=20")
        )
    }
    
    func test_episodesWithMaxParameter() {
        XCTAssertEqual(
            Endpoint.episodes(by: 75075, max: 1).url,
            URL(string: "https://api.podcastindex.org/api/1.0/episodes/byfeedid?id=75075&max=1")
        )
    }
    
    func test_recentFeedsByCategory() {
        let testCategory = Models.Category(id: 1, name: "Baz")
        
        XCTAssertEqual(
            Endpoint.recentFeeds(by: testCategory).url,
            URL(string: "https://api.podcastindex.org/api/1.0/recent/feeds?cat=\(testCategory.name)&max=20")
        )
    }
    
    func test_recentFeedsByCategoryWithMaxParameter() {
        let testCategory = Models.Category(id: 1, name: "Baz")
        
        XCTAssertEqual(
            Endpoint.recentFeeds(by: testCategory, max: 1).url,
            URL(string: "https://api.podcastindex.org/api/1.0/recent/feeds?cat=\(testCategory.name)&max=1")
        )
    }
    
    func test_recentFeeds() {
        XCTAssertEqual(
            Endpoint.recentFeeds().url,
            URL(string: "https://api.podcastindex.org/api/1.0/recent/feeds?max=20")
        )
    }
    
    func test_recentFeedsWithMaxParameter() {
        XCTAssertEqual(
            Endpoint.recentFeeds(max: 1).url,
            URL(string: "https://api.podcastindex.org/api/1.0/recent/feeds?max=1")
        )
    }
    
    func test_feedsByMedium() {
        XCTAssertEqual(
            Endpoint.feeds(by: .audiobook).url,
            URL(string: "https://api.podcastindex.org/api/1.0/podcasts/bymedium?medium=audiobook&max=20")
        )
    }
    
    func test_feedsByMediumWithMaxParameter() {
        XCTAssertEqual(
            Endpoint.feeds(by: .audiobook, max: 1).url,
            URL(string: "https://api.podcastindex.org/api/1.0/podcasts/bymedium?medium=audiobook&max=1")
        )
    }

}
