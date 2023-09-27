//
//  PlaylistObject.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import RealmSwift
import Models

final class PlaylistObject: Object, ObjectKeyIdentifiable {
    @Persisted var id: UUID
    @Persisted var image: String
    @Persisted var name: String
    @Persisted var episodes: List<EpisodeObject>
    
    init(playlist: Playlist) {
        super.init()
        self.id = playlist.id
        self.image = playlist.image
        self.name = playlist.name
        self.episodes.append(objectsIn: playlist.episodes.map(EpisodeObject.init))
    }
}
