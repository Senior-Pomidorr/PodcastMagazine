//
//  Playlist.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models
import RealmSwift

extension Playlist: Persistable {
    public typealias ManagedObject = PlaylistObject
    
    //MARK: - PropertyValue
    public enum PropertyValue: PropertyValueType {
        case id(UUID)
        case image(String)
        case name(String)
        case episodes([Episode])
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case let .id(id): return ("id", id)
            case let .image(image): return ("image", image)
            case let .name(name): return ("name", name)
            case let .episodes(episodes): return ("episodes", episodes.map(EpisodeObject.init))
            }
        }
    }
    
    //MARK: - init(managedObject:)
    public init(_ managedObject: PlaylistObject) throws {
        let episodes = try managedObject.episodes.map(Episode.init)
        self.init(
            id: managedObject.id,
            image: managedObject.image,
            name: managedObject.name,
            episodes: episodes
        )
    }
    
    public func managedObject() -> PlaylistObject {
        PlaylistObject(playlist: self)
    }
}
