//
//  SoundManager.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Foundation
import Combine

class SoundManager {

    private var player: AVPlayer = AVPlayer()
    
    var urlString: String = .init()
    
    /// общая продолжительность трека
    var duration: TimeInterval {
        if player.status == .readyToPlay {
            return player.currentItem?.duration.seconds ?? 0.0
        }
        
        return 0.0
    }
    
    /// текущее время трека
    var currentTime: TimeInterval {
        if player.status == .readyToPlay {
            return player.currentTime().seconds
        }
        
        return 0.0
    }
    
    /// отсчет времени до завершения трека
    var timeleft: TimeInterval {
        if player.status == .readyToPlay {
            // unwrap возможно стоит заменить на duration
            // поидее проблем не должно быть так как проверяю статус плеера
            return (player.currentTime() - player.currentItem!.duration).seconds
        }
        
        return 0.0
    }
    
    
    init(
        urlString: String = .init(),
        player: AVPlayer = AVPlayer()
    ) {
        self.urlString = urlString
        self.player = player
    }
    
    /// Создает AVPlayerItem
    /// автоматичести загружает по URL и отслеживает status
    /// так же добавляет item в AVPlayer
    /// - Returns: AnyPublisher<AVPlayerItem.Status, Never>
    func playMedia() -> AnyPublisher<AVPlayerItem.Status, Never> {
        guard let url = URL(string: urlString) else {
            return Just(.failed).eraseToAnyPublisher()
        }
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(
                asset: asset,
                automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
            )
        
        player.replaceCurrentItem(with: playerItem)

        return playerItem.publisher(for: \.status)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()

    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    /// Поиск по временной шкале трека
//    func seek(to timeInterval: TimeInterval) {
//        let time = CMTime(seconds: timeInterval, preferredTimescale: 600)
//        player.seek(to: time)
//    }
    
    /// Поиск по временной шкале трека `async`
    func seek(to timeInterval: TimeInterval) async {
        let time = CMTime(seconds: timeInterval, preferredTimescale: 600)
        await player.seek(to: time)
    }
}
