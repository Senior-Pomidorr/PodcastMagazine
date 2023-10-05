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
    
    func test_deleteExactFeed() throws {
        let secondFeed = Feed(
            id: 2,
            url: "Bar",
            title: "Bar",
            description: "Bar",
            image: nil,
            author: nil,
            ownerName: nil,
            artwork: nil,
            language: "Bar",
            medium: nil,
            episodeCount: nil,
            categories: nil
        )
        
        try sut.write {
            $0.add(self.testFeed)
            $0.add(secondFeed)
        }
        
        var result = sut.values(Feed.self)
        
        XCTAssertEqual(result.count, 2)
        
        try sut.write {
            $0.delete(self.testFeed)
        }
        
        result = sut.values(Feed.self)
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertFalse(result.contains(testFeed))
    }
    
    func test_addUserAccount() throws {
        let testUser = UserAccount(firstName: "Baz", lastName: "Bar", email: "Foo")
        
        try sut.write {
            $0.add(testUser)
        }
        
        let result = sut.values(UserAccount.self)
        
        XCTAssertTrue(result.contains(testUser))
    }
    
    func test_deleteExactUser() throws {
        let firstUser = UserAccount(firstName: "Baz", lastName: "Bar", email: "Foo")
        let secondUser = UserAccount(firstName: "Bar", lastName: "Baz", email: "Bar")
        
        try sut.write {
            $0.add(firstUser)
            $0.add(secondUser)
        }
        
        var result = sut.values(UserAccount.self)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains(firstUser))
        
        try sut.write {
            $0.delete(firstUser)
        }
        
        result = sut.values(UserAccount.self)
        
        XCTAssertFalse(result.contains(firstUser))
        XCTAssertFalse(result.isEmpty)
    }

}
