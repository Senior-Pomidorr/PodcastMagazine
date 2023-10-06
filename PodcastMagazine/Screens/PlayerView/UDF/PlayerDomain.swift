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
        var playerStatus: ScreenStatus
        
        var currdentIndex: Int = .init()
        
        var duration: TimeInterval
        var currentTime: TimeInterval
        var timeLeft: TimeInterval
        var sliderValue: TimeInterval
        // UI properties
        var title: String
        var image: String
        
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
            image: String = .init()
        ) {
            self.episodes = episodes
            self.selectedEpisod = selectedEpisod
            self.playerStatus = playerStatus
            self.duration = duration
            self.currentTime = currentTime
            self.timeLeft = timeLeft
            self.sliderValue = sliderValue
            self.title = title
            self.image = image
        }
        
        // MARK: - Methods
        func findEpisideBy(id: Int) -> Episode {
            return episodes.first { $0.id == id}!
        }
        
        func findIndexBy(_ episod: Episode) -> Int? {
            return episodes.firstIndex(of: episod)
        }
        
        func findNextEpisode() -> Episode? {
            if  currdentIndex < episodes.count - 1 {
                let index = currdentIndex + 1
                return episodes[index]
            }
            return nil
        }
        
        func findPreviousEpisode() -> Episode? {
            if (currdentIndex - 1) >= 0 {
                let index = currdentIndex - 1
                return episodes[index]
            }
            return nil
        }
        
        func createUrl(from episode: Episode?) -> URL? {
            if let episode,
                let url = URL(string: episode.enclosureUrl) {
                return url
            }
            return nil
        }
    }
    
    // MARK: - Action
    enum Action {
        case onAppeared
        case play
        case pause
        case updateSliderValue
        case nextAudio
        case backAudio
        case _playerResponse(AVPlayerItem.Status)
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
            
            guard state.playerStatus != .loading else {
                break
            }
            // first start
            state.playerStatus = .loading
            audioManager.url = state.createUrl(from: state.selectedEpisod)
            state.currdentIndex = state.findIndexBy(state.selectedEpisod) ?? 0
            state.title = state.selectedEpisod.title
            state.image = state.selectedEpisod.image
            
            return audioManager.playMedia()
                .map(Action._playerResponse)
                .eraseToAnyPublisher()
            
        case ._playerResponse(.readyToPlay):
            state.playerStatus = .none
            state.duration = audioManager.duration
            
        case ._playerResponse(.failed):
            let error = PlayerError.failLoading
            state.playerStatus = .error(error)
  
        case .play:
            audioManager.play()
        case .pause:
            audioManager.pause()
            
        case .nextAudio:
            //...
            break
            
        case .backAudio:
            //...
            break
            
        case .updateSliderValue:
            state.sliderValue = audioManager.currentTime
  
        case let .seek(timeInterval):
            state.sliderValue = timeInterval
            Task {
                await audioManager.seek(to: timeInterval)
            }
            
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
