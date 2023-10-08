//
//  PlayerView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI
import LoadableImage
import Models

struct PlayerView: View {
    @StateObject private var store: PlayerStore
    @AppStorage("isShowingSmallPlayer") var isShowingSmallPlayer: Bool = true
    
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            
            switch store.state.screenStatus {
            case .none:
                PlayerContentView(
                    image: store.state.image,
                    title: store.state.title,
                    playButtonAction: { store.send(.playButtonTap) },
                    nextButtonAction: { store.send(.nextButtonTap) },
                    previousButtonAction: { store.send(.previousButtonTap) }, 
                    shuffleButtonAction: { store.send(.shuffleButtonTap) },
                    isPlaying: store.state.isPlaying,
                    sliderValue: bindingSlider(),
                    duration: store.state.duration,
                    timeLeft: store.state.timeLeft,
                    isShuffled: store.state.isShuffled
                )
                
            case .loading:
                LoadingPlayerView()
                
            case .error(let error):
                ErrorPlayerView(error: error)
            }
        }
        .onAppear {
            store.send(.onAppeared)
            isShowingSmallPlayer = true
            ObserverAudioPlayer.shared.isShowingSmallPlayer = false
        }
        .onReceive(timer) { _ in
            store.send(.updateSliderValue)
        }
        .onDisappear {
            ObserverAudioPlayer.shared.isShowingSmallPlayer = true
        }
    }
    
    // MARK: - binding
    func bindingSlider() -> Binding<TimeInterval> {
        .init {
            store.state.currentTime
        } set: {
            store.send(.seek($0))
        }
    }
    
    // MARK: - init(:)
    init(
        selectedEpisode: Episode,
        episodes: [Episode]
    ) {
        let store = PlayerStore(
            state: PlayerDomain.State(
                episodes: episodes,
                selectedEpisode: selectedEpisode),
            reducer: PlayerDomain()
        )
        
        _store = .init(wrappedValue: store)
    }
}

#Preview {
    PlayerView(
        selectedEpisode: Episode.sample,
        episodes: [Episode.sample]
    )
}
