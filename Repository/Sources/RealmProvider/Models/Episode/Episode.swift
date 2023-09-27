//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models

extension Episode: Persistable {
    //MARK: - init(managedObject:)
    init(_ managedObject: EpisodeObject) throws {
        guard
            let link = URL(string: managedObject.link),
            let enclosureUrl = URL(string: managedObject.enclosureUrl),
            let image = URL(string: managedObject.image),
            let feedImage = URL(string: managedObject.feedImage)
        else {
            throw RealmError.missingValue
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
    
    func managedObject() -> EpisodeObject {
        EpisodeObject(episode: self)
    }
}
