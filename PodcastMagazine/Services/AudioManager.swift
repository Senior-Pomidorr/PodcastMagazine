//
//  SoundManager.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Foundation
import Combine

extension Optional {
    var throwingPublisher: AnyPublisher<Wrapped, Error> {
        switch self {
        case .none:
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        case .some(let wrapped):
            return Just(wrapped)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

class AudioManager {
    static let shared = AudioManager()

    private var player: AVPlayer = AVPlayer()
    var url: URL?
    
    func status() -> AnyPublisher<AVPlayer.Status, Never> {
        player.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func currentItem() -> AnyPublisher<AVPlayerItem?, Never> {
        player.publisher(for: \.currentItem)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
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
    var timeLeft: TimeInterval {
        if player.status == .readyToPlay {
            // unwrap возможно стоит заменить на duration
            // поидее проблем не должно быть так как проверяю статус плеера
            return (player.currentTime() - player.currentItem!.duration).seconds
        }
        
        return 0.0
    }
    
    
    private init(
        url: URL? = nil,
        player: AVPlayer = AVPlayer()
    ) {
        self.url = url
        self.player = player
        
        player.volume = 0.15
    }
    
    /// Создает AVPlayerItem
    /// автоматичести загружает по URL и отслеживает status
    /// так же добавляет item в AVPlayer
    /// - Returns: AnyPublisher<AVPlayerItem.Status, Never>
    func playMedia(url: URL? = nil) -> AnyPublisher<AVPlayer.Status, Never> {
        url.publisher
            .map(AVAsset.init)
            .map(playerWith(asset:))
            .flatMap(replaceItem(in: player))
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
    
    /// Поиск по временной шкале трека `async`
    func seek(to timeInterval: TimeInterval) async {
        let time = CMTime(seconds: timeInterval, preferredTimescale: 600)
        await player.seek(to: time)
    }
}

// MARK: - playbackMode
extension AudioManager {
    static func playbackMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Попытка включить \"playback\" неудачна")
        }
    }
}

// MARK: - Winamp intro
private extension AudioManager {
     func winampIntro() {
        guard let url = Bundle.main.url(forResource: "winampIntro", withExtension: ".mp3") else {
            return
        }
        
        
//        let intro = AVPlayerItem(asset: AVAsset(url: url))
        
        // пока нету реализации
        // если дойдут руки сделаю
    }
    
    func playerWith(asset: AVAsset) -> AVPlayerItem {
        AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
        )
    }
    
    func replaceItem(in player: AVPlayer) -> (AVPlayerItem) -> AnyPublisher<AVPlayer.Status, Never> {
        { item in
            player.replaceCurrentItem(with: item)
            return player
                .publisher(for: \.status)
                .eraseToAnyPublisher()
        }
    }
    
}
