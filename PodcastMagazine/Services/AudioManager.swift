//
//  SoundManager.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Foundation
import Combine

class AudioManager {
    static let shared = AudioManager()

    private var player: AVPlayer = AVPlayer()
    var url: URL?
    
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
    func playMedia() -> AnyPublisher<AVPlayerItem.Status, Never> {
        guard let url = url else {
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
extension AudioManager {
    private func winampIntro() {
        guard let url = Bundle.main.url(forResource: "winampIntro", withExtension: ".mp3") else {
            return
        }
        
//        let intro = AVPlayerItem(asset: AVAsset(url: url))
        
        // пока нету реализации
        // если дойдут руки сделаю
    }
}
