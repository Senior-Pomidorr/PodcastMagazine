//
//  PlaylistObject.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift
import Models

public final class PlaylistObject: Object, ObjectKeyIdentifiable {
    @Persisted public var id: UUID
    @Persisted public var image: String
    @Persisted public var name: String
    @Persisted public var episodes: List<EpisodeObject>
    
    init(playlist: Playlist) {
        super.init()
        self.id = playlist.id
        self.image = playlist.image
        self.name = playlist.name
        self.episodes.append(objectsIn: playlist.episodes.map(EpisodeObject.init))
    }
}
