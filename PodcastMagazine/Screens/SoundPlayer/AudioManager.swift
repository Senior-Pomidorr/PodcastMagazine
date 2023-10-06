//
//  AudioManager.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Foundation

class AudioManager {
    
    var playerQueue: AVQueuePlayer?
    var playlist: [AVPlayerItem]
    
    /// текущее время трека
    var currentTime: Double {
        playerQueue?.currentTime().seconds ?? 0.0
    }
    /// длительность трека
    var duration: Double {
        playerQueue?.currentItem?.duration.seconds ?? 0.0
    }
    
    /// вычисляет текущий индекс трека или 0
    private var indexCurrentTrack: Int {
        if let item = playerQueue?.currentItem,
           let index = playlist.firstIndex(of: item) {
            return index
        }
        
        return 0
    }
    
    // MARK: - init(:)
    init(
        playerQueue: AVQueuePlayer? = nil,
        playlist: [AVPlayerItem] = []
    ) {
        self.playlist = .init()
        
        winampIntro()
    }
    
    /// добавить трек в плейлист на последнее место
    func addTrackBy(url urlString: String) {
        guard let urlTrack = URL(string: urlString) else {
            return
        }
        
        let playerItem = AVPlayerItem(asset: AVAsset(url: urlTrack))
        
        playlist.insert(contentsOf: [playerItem], at: 1)
    }
    
    /// подготовить плеер для прослушивания последнего трека в playList
    /// Можно получить данные спустя немного времени когда трек начнет подгружаться
    func preperPlayer() {
        playerQueue = AVQueuePlayer(items: playlist)
    }
    
    // MARK: - Player Inteface
    func play() {
        playerQueue?.play()
    }
    
    func pause() {
        playerQueue?.pause()
    }
    
    func next() {
        if playlist.count - 1 > indexCurrentTrack {
            playerQueue?.advanceToNextItem()
        }
    }
    
    func back() {
        if indexCurrentTrack > 0 {
            playerQueue?.replaceCurrentItem(with: playlist[indexCurrentTrack - 1])
        }
    }
    /// поиск нужного времени в треке
    func seek(_ value: Double) {
        let time = CMTime(seconds: value, preferredTimescale: 1_000_000)
        playerQueue?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func toggleLoop() {
        // какой-то функционал который зацикливает трек
    }
    
    func pListCount() {
        print("\(playlist.count)")
    }
    
    func winampIntro() {
        guard let url = Bundle.main.url(forResource: "winampIntro", withExtension: ".mp3") else {
            return
        }
        
        let intro = AVPlayerItem(asset: AVAsset(url: url))
        playlist.append(intro)
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
