//
//  PlayerView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI
import LoadableImage
import Models

struct PlayButton: View {
    var isPlaying: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(Color.blue)
                .frame(width: 64, height: 64)
                .overlay {
                    Image(systemName: isPlaying
                          ? "pause.fill"
                          : "play.fill"
                    )
                    .font(.title)
                    .foregroundStyle(.white)
                }
        }
    }
}

struct PlayerView: View {
    @StateObject private var store: PlayerStore
    @State private var isEditing = false
//    @State private var isPlaying = true
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            
            switch store.state.screenStatus {
            case .none:
                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center) {
                            Spacer()
                            LoadableImage(store.state.image) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.50)
                            .background(Color("tintBlue2"))
                            .cornerRadius(16)
                            .shadow(radius: 8)
                            Spacer()
                        }
                        
                        VStack(spacing: 0) {
                            Text(store.state.title)
                                .font(.custom(.bold, size: 16))
                                .kerning(0.32)
                                .lineLimit(2)
                        }
                        .padding(.top, 36)
                        
                        SliderStack(
                            sliderValue: bindingSlider(),
                            isEditing: $isEditing,
                            duration: store.state.duration,
                            startTime: "",
                            timeLeft: ""
                        )
                        
                        HStack(alignment: .center, spacing: 32) {
                            ShuffleButton()
                            
                            Button {
                                store.send(.previousAudio)
                            } label: {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                            
                            PlayButton(
                                isPlaying: store.state.isPlaying,
                                action: { store.send(.playButtonTap) }
                            )
                            
                            Button {
                                store.send(.nextAudio)
                            } label: {
                                Image("nextTrack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                            
                            RepeatButton()
                        }
                        .padding(.horizontal, 48)
                        .padding(.top, 50)
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("Now playing")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
                
            case .loading:
                VStack {
                    ProgressView()
                }
                .navigationTitle("Now playing")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
                
            case .error(let error):
                Text("Экран ошибки, ошибка: \(error.localizedDescription)")
            }
        }
        .onAppear {
            store.send(.onAppeared)
        }
        .onReceive(timer) { _ in
            if !isEditing {
                store.send(.updateSliderValue)
            }
        }
    }
    
    // MARK: - binding
    func bindingSlider() -> Binding<TimeInterval> {
        .init {
            store.state.sliderValue
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
                selectedEpisod: selectedEpisode),
            reducer: PlayerDomain(audioManager: AudioManager())
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
