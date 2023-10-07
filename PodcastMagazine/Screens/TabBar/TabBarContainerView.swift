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
    @State private var showPlayer: Bool = false
    let content: Content
    
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
                SmallAudioPlayerView()
                //TODO: - PLAYER VIEW
            }
            
            if !hideTabBar {
                TabBarView(tabs: tabs, selection: $selection)
            }
        }
        .onPreferenceChange(TabBarItemsPreferencesKey.self, perform: { value in
            self.tabs = value
        })
    }
}
