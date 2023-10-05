//
//  Playlist.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI
import Models

struct PlaylistView: View {
    @StateObject var store: PlaylistStore = PlayListDomain.playlistDomainLive
    var mockFeed: [Feed] = [Feed.sample]
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Text("See All")
                            .foregroundColor(Color("GreyTextColor"))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 28)
                switch store.state.playlistStatus {
                case .none:
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(store.state.favoritesList) {item in
                                FavoritesCell(feed: item)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 28)
                    }
                default:
                    EmptyView()
                }
                
                HStack {
                    Text("Your Playlist")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 28)
                List {
                    NavigationLink {
                        CreatePlaylistView()
                    } label: {
                        CreatePlaylistButton()
                    }

                    ForEach(store.state.playlistList) {feed in
                        ForEach(1..<20) {repeatFeed in
                            PlaylistCell(playlist: feed)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    PlaylistView()
}
