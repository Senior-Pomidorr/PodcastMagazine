//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models

extension Episode: Persistable {
    public typealias ManagedObject = EpisodeObject
    
    //MARK: - PropertyValue
    public enum PropertyValue: PropertyValueType {
        case id(Int)
        case title(String)
        case link(String)
        case description(String)
        case guid(String)
        case datePublished(Int)
        case datePublishedPretty(String)
        case dateCrawled(Int)
        case enclosureUrl(String)
        case explicit(Int)
        case episode(Int)
        case episodeType(EpisodeType?)
        case season(Int)
        case image(String)
        case feedImage(String)
        case feedId(Int)
        case feedTitle(String)
        case feedLanguage(String)
        case chaptersUrl(String)
        
        public var propertyValuePair: PropertyValuePair {
            return ("", "")
        }
    }
    
    //MARK: - init(managedObject:)
    public init(_ managedObject: EpisodeObject) {
        self.init(
            id: managedObject.id,
            title: managedObject.title,
            link: managedObject.link,
            description: managedObject.episodeDescription,
            guid: managedObject.guid,
            datePublished: managedObject.datePublished,
            datePublishedPretty: managedObject.datePublishedPretty,
            dateCrawled: managedObject.dateCrawled,
            enclosureUrl: managedObject.enclosureUrl,
            explicit: managedObject.explicit,
            episode: managedObject.episode,
            episodeType: managedObject.episodeType,
            season: managedObject.season,
            image: managedObject.image,
            feedImage: managedObject.feedImage,
            feedId: managedObject.feedId,
            feedTitle: managedObject.feedTitle,
            feedLanguage: managedObject.feedLanguage,
            chaptersUrl: managedObject.chaptersUrl
        )
    }
    
    public func managedObject() -> EpisodeObject {
        EpisodeObject(episode: self)
    }
}
