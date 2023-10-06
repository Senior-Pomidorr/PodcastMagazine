//
//  FavoritesView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 05.10.2023.
//

import SwiftUI
import Models

struct FavoritesView: View {
    var mockFeed: [Feed] = [Feed.sample]
    var body: some View {
        NavigationView {
            List {
                ForEach(mockFeed, id: \.id) {feed in
                    ForEach(1..<20) {repeatFeed in
                        PlaylistCell(playlist: Playlist.sample)
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Favorites")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .padding(.horizontal)
    }
}

#Preview {
    FavoritesView()
}
