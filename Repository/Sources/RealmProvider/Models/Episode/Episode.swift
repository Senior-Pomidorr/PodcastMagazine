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
        case link(URL)
        case description(String)
        case guid(String)
        case datePublished(Int)
        case datePublishedPretty(String)
        case dateCrawled(Int)
        case enclosureUrl(URL)
        case explicit(Int)
        case episode(Int?)
        case episodeType(EpisodeType?)
        case season(Int?)
        case image(URL)
        case feedImage(URL)
        case feedId(Int)
        case feedTitle(String)
        case feedLanguage(String)
        case chaptersUrl(URL?)
        
        public var propertyValuePair: PropertyValuePair {
            return ("", "")
        }
    }
    
    //MARK: - init(managedObject:)
    public init(_ managedObject: EpisodeObject) throws {
        guard
            let link = URL(string: managedObject.link),
            let enclosureUrl = URL(string: managedObject.enclosureUrl),
            let image = URL(string: managedObject.image),
            let feedImage = URL(string: managedObject.feedImage)
        else {
            throw RealmManager.RealmError.missingValue
        }
        self.init(
            id: managedObject.id,
            title: managedObject.title,
            link: link,
            description: managedObject.episodeDescription,
            guid: managedObject.guid,
            datePublished: managedObject.datePublished,
            datePublishedPretty: managedObject.datePublishedPretty,
            dateCrawled: managedObject.dateCrawled,
            enclosureUrl: enclosureUrl,
            explicit: managedObject.explicit,
            episode: managedObject.episode,
            episodeType: managedObject.episodeType,
            season: managedObject.season,
            image: image,
            feedImage: feedImage,
            feedId: managedObject.feedId,
            feedTitle: managedObject.feedTitle,
            feedLanguage: managedObject.feedLanguage,
            chaptersUrl: URL(string: managedObject.chaptersUrl ?? "")
        )
    }
    
    public func managedObject() -> EpisodeObject {
        EpisodeObject(episode: self)
    }
}
