//
//  Category.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public struct Category: Identifiable, Decodable {
    public let id: Int
    public let name: String
    
    //MARK: - init(_:)
    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case feeds
        case id
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .feeds)
        self.id = try nestedContainer.decode(Int.self, forKey: .id)
        self.name = try nestedContainer.decode(String.self, forKey: .name)
    }
    
    //MARK: - Sample
    public static let sample: Category = .init(
        id: 2,
        name: "Books"
    )
}
