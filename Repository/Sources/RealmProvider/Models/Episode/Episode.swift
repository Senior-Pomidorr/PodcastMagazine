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
        case episodeType(EpisodeType)
        case season(Int)
        case image(String)
        case feedImage(String)
        case feedId(Int)
        case feedTitle(String)
        case feedLanguage(String)
        case chaptersUrl(String)
        
        public var propertyValuePair: PropertyValuePair {
            switch self {
            case let .id(id):                    return ("id", id)
            case let .title(title):              return ("title", title)
            case let .link(link):                return ("link", link)
            case let .description(description):  return ("description", description)
            case let .guid(guid):                return ("guid", guid)
            case let .datePublished(date):       return ("datePublished", date)
            case let .datePublishedPretty(date): return ("datePublishedPretty", date)
            case let .dateCrawled(date):         return ("dateCrawled", date)
            case let .enclosureUrl(url):         return ("enclosureUrl", url)
            case let .explicit(explicit):        return ("explicit", explicit)
            case let .episode(episode):          return ("episode", episode)
            case let .episodeType(type):         return ("episodeType", type)
            case let .season(season):            return ("season", season)
            case let .image(url):                return ("image", url)
            case let .feedImage(url):            return ("feedImage", url)
            case let .feedId(id):                return ("feedId", id)
            case let .feedTitle(title):          return ("feedTitle", title)
            case let .feedLanguage(language):    return ("feedLanguage", language)
            case let .chaptersUrl(url):          return ("chaptersUrl", url)
            }
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
