//
//  PlayerDomain.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 05.10.23.
//

import AVKit
import Combine
import Models
import Foundation

enum PlayerError: Error {
    case failLoading
}

struct PlayerDomain {
    // MARK: - State
    struct State {
        // player properties
        var episodes: [Episode]
        var selectedEpisod: Episode
        var screenStatus: ScreenStatus
        
        var currdentIndex: Int = .init()
        
        var duration: TimeInterval
        var currentTime: TimeInterval
        var timeLeft: TimeInterval
        var sliderValue: TimeInterval
        // UI properties
        var title: String
        var image: String
        
        var isPlaying: Bool
        
        // MARK: - init(:)
        init(
            episodes: [Episode] = .init(),
            selectedEpisod: Episode = Episode.sample,
            playerStatus: ScreenStatus = .none,
            duration: TimeInterval = .init(),
            currentTime: TimeInterval = .init(),
            timeLeft: TimeInterval = .init(),
            sliderValue: TimeInterval = .init(),
            title: String = .init(),
            image: String = .init(),
            isPlaying: Bool = false
        ) {
            self.episodes = episodes
            self.selectedEpisod = selectedEpisod
            self.screenStatus = playerStatus
            self.duration = duration
            self.currentTime = currentTime
            self.timeLeft = timeLeft
            self.sliderValue = sliderValue
            self.title = title
            self.image = image
            self.isPlaying = isPlaying
        }
        
        // MARK: - Methods
        func findEpisideBy(id: Int) -> Episode {
            return episodes.first { $0.id == id }!
        }
        
        func findIndexBy(_ episod: Episode) -> Int? {
            return episodes.firstIndex(of: episod)
        }
        
        func findNextEpisode() -> Episode? {
            guard currdentIndex < episodes.count - 1 else {
                return nil
            }
            let index = currdentIndex + 1
            return episodes[index]
        }
        
        func findPreviousEpisode() -> Episode? {
            guard (currdentIndex - 1) >= 0 else {
                return nil
            }
            let index = currdentIndex - 1
            return episodes[index]
        }
        
        func createUrl(from episode: Episode?) -> URL? {
            guard let url = episode.map(\.enclosureUrl) else {
                return nil
            }
            return URL(string: url)
        }
    }
    
    // MARK: - Action
    enum Action {
        case onAppeared
        case playButtonTap
//        case play
//        case pause
        case updateSliderValue
        case nextAudio
        case previousAudio
        case _playerResponse(AVPlayer.Status)
        case seek(TimeInterval) // поиск места на треке (прогресс или перемотка)
    }
    
    // MARK: - Dependencies
    let audioManager: AudioManager
    
    // MARK: - func reduce
    func reduce(
        _ state: inout State,
        action: Action
    ) -> AnyPublisher<Action, Never> {
        
        switch action {
        case .onAppeared:
            
            guard state.screenStatus != .loading else {
                break
            }
            // first start
            state.screenStatus = .loading
            audioManager.url = state.createUrl(from: state.selectedEpisod)
            state.currdentIndex = state.findIndexBy(state.selectedEpisod) ?? 0
            
            return audioManager.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case ._playerResponse(.readyToPlay):
            state.screenStatus = .none
            state.sliderValue = 0.0
            state.duration = audioManager.duration
            state.title = state.selectedEpisod.title
            state.image = state.selectedEpisod.image
            // play
            audioManager.play()
            
        case ._playerResponse(.failed):
            let error = PlayerError.failLoading
            state.screenStatus = .error(error)
  
        case .playButtonTap:
            state.isPlaying.toggle()
            
            switch state.isPlaying {
            case true:
                audioManager.play()
                
            case false:
                audioManager.pause()
            }
            
//        case .play:
//            
//        case .pause:
//            
            
        case .nextAudio:
            if let episode = state.findNextEpisode() {
                audioManager.pause()
                state.screenStatus = .loading
                state.currdentIndex = state.findIndexBy(episode) ?? 0
                state.selectedEpisod = episode
                
                audioManager.url = state.createUrl(from: episode)
            } else {
                // если эпизод не найден выходим
                break
            }
            
            return audioManager.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case .previousAudio:
            guard let episode = state.findPreviousEpisode() else {
                break
            }
            audioManager.pause()
            state.screenStatus = .loading
            state.currdentIndex = state.findIndexBy(episode) ?? 0
            state.selectedEpisod = episode
            
            
            return audioManager.playMedia(url: state.createUrl(from: episode))
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case .updateSliderValue:
            state.sliderValue = audioManager.currentTime
            
        case let .seek(timeInterval):
            state.sliderValue = timeInterval
            
            return Future<Action, Never> { promise in
                Task {
                    await audioManager.seek(to: timeInterval)
                    promise(.success(.updateSliderValue))
                }
            }
            .eraseToAnyPublisher()
            
            
        case ._playerResponse(_):
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}


class PlayerStore: ObservableObject {
    @Published private(set) var state: PlayerDomain.State
    
    private var reducer: PlayerDomain
    private var cancelleble: Set<AnyCancellable> = .init()
    
    init(
        state: PlayerDomain.State,
        reducer: PlayerDomain
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    func send(_ action: PlayerDomain.Action) {
        reducer.reduce(&state, action: action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send(_:))
            .store(in: &cancelleble)
    }
}
