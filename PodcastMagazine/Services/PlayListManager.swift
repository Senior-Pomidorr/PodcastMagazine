//
//  PlayList.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 08.10.23.
//

import Foundation
import Models

class PlayListManager {
    static let shared = PlayListManager()
    
    private init() {}
    
    var episodes: [Episode]?
    var currentEpisode: Episode?
    
    private var indexCurrentEpisode: Int {
        guard let episode = currentEpisode else {
            return 0
        }
        guard let index = episodes?.firstIndex(of: episode) else {
            return 0
        }
        return index
    }
    
    func getNextAudio() -> Episode? {
        guard let episodes = episodes else { return nil }
        guard indexCurrentEpisode < episodes.count - 1 else { return nil }
        let index = indexCurrentEpisode + 1
        currentEpisode = episodes[index]
        return episodes[index]
    }
    
    func getPreviousAudio() -> Episode? {
        guard let episodes = episodes else { return nil }
        guard (indexCurrentEpisode - 1) >= 0 else { return nil }
        let index = indexCurrentEpisode - 1
        currentEpisode = episodes[index]
        return episodes[index]
    }
    
    func setPlayList(_ episodes: [Episode], and currentEpisode: Episode) {
        self.episodes = episodes
        self.currentEpisode = currentEpisode
    }
    
    func playList(_ isShuffled: Bool) -> [Episode]? {
        guard let episodes = episodes else { return nil }
        switch isShuffled {
        case true:
            return episodes.shuffled()
        case false:
            return episodes.sorted(by: { $0.title < $1.title })
        }
    }
}
