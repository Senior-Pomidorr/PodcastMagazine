//
//  TabBarContainerView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import Foundation
import SwiftUI

struct TabBarContainerView<Content:View>: View {
    
    @AppStorage("tabBar") var hideTabBar = false
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    @State private var showPlayer: Bool = ObserverAudioPlayer.shared.isShowingSmallPlayer
    let content: Content
    
    @StateObject private var store = SmallPlayerDomain.live
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            
            if showPlayer {
                SmallAudioPlayerView(
                    title: store.state.title,
                    urlImage: store.state.imageUrl,
                    playButtonAction: { store.send(.playButtonTap) },
                    nextButtonAction: { store.send(.nextButtonTap) },
                    previousButtonAction: { store.send(.previousButtonTap) },
                    isPlaying: store.state.isPlaying
                )
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.height > 0 {
                                            ObserverAudioPlayer.shared.isShowingSmallPlayer = false
                                        }
                                    }))
            }
            
            if !hideTabBar {
                TabBarView(tabs: tabs, selection: $selection)
            }
        }
        .onPreferenceChange(TabBarItemsPreferencesKey.self, perform: { value in
            self.tabs = value
        })
        .onReceive(timer) { _ in
            store.send(.appeared)
            showPlayer = ObserverAudioPlayer.shared.isShowingSmallPlayer
        }
    }
}
