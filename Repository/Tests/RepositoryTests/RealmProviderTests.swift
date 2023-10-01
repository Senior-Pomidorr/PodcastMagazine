//
//  RealmProviderTests.swift
//  
//
//  Created by Илья Шаповалов on 29.09.2023.
//

import XCTest
import RealmProvider
import RealmSwift
import Models

final class RealmProviderTests: XCTestCase {
    private var sut: RealmManager!
    private var testFeed: Feed!
    private var exp: XCTestExpectation!
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let config = Realm.Configuration(inMemoryIdentifier: "RealmProviderTests")
        
        sut = try RealmManager(config: config)
        testFeed = Feed(
            id: 1,
            url: "Baz",
            title: "Baz",
            description: "Baz",
            image: "Baz",
            author: "Baz",
            ownerName: "Baz",
            artwork: "Baz",
            language: "Baz",
            medium: .audiobook,
            episodeCount: 1,
            categories: ["Baz": "Bar"]
        )
        exp = .init(description: "RealmProviderTests")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        testFeed = nil
        exp = nil
        
        try super.tearDownWithError()
    }
    
    func test_createModels() throws {
        var result = sut.values(Feed.self)
        
        XCTAssertTrue(result.isEmpty)
        
        try sut.write { transaction in
            transaction.add(self.testFeed)
        }
        
        result = sut.values(Feed.self)
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.first, testFeed)
    }
    
    func test_deleteModel() throws {
        try sut.write {
            $0.add(self.testFeed)
        }
        
        var result = sut.values(Feed.self)
        
        XCTAssertEqual(result.first, testFeed)
        
        try sut.write {
            $0.delete(self.testFeed)
        }
        
        result = sut.values(Feed.self)
        
        XCTAssertTrue(result.isEmpty)
    }

}
