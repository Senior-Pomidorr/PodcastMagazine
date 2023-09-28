//
//  Playlist.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation

public struct Playlist: Identifiable, Decodable, Equatable {
    public let id: UUID
    public let image: String
    public let name: String
    public let episodes: [Episode]
    
    public init(
        id: UUID,
        image: String,
        name: String,
        episodes: [Episode]
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.episodes = episodes
    }
    
    public static let sample = Self(
        id: .init(), 
        image: "image",
        name: "Fucking best playlist ever!",
        episodes: [.sample]
    )
}
