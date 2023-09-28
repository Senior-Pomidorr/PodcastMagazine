//
//  Playlist.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI
import Models

struct PlaylistView: View {
    var mockFeed: [Feed] = [Feed.sample]
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    NavigationLink {
                        //See All present
                    } label: {
                        Text("See All")
                            .foregroundColor(Color("GreyTextColor"))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 28)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        FavoritesCell()
                        FavoritesCell()
                        FavoritesCell()
                        FavoritesCell()
                        FavoritesCell()
                        FavoritesCell()
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, 28)
                HStack {
                    Text("Your Playlist")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 28)
                List {
                    CreatePlaylistButton()
                    ForEach(mockFeed, id: \.id) {feed in
                        ForEach(1..<20) {repeatFeed in
                            PlaylistCell(namePodcast: feed.title, partPodcast: feed.title)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .listStyle(PlainListStyle())
            }
            navigationTitle("Playlist")
        }
    }
}


#Preview {
    PlaylistView()
}
