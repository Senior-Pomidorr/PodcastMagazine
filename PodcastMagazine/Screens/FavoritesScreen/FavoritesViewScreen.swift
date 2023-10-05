//
//  FavoritesView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 05.10.2023.
//

import SwiftUI
import Models

struct FavoritesViewScreen: View {
    var mockFeed: [Feed] = [Feed.sample]
    var body: some View {
        NavigationView {
            List {
                ForEach(mockFeed, id: \.id) {feed in
                    ForEach(1..<20) {repeatFeed in
                        PlaylistCell(namePodcast: "Title", partPodcast: "Subtitle")
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .padding(.horizontal, 8)
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Favorites")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .padding(.horizontal)
    }
}

#Preview {
    FavoritesViewScreen()
}
