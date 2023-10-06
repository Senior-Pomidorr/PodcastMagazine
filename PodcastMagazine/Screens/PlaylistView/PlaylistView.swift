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
                        .font(.custom(.bold, size: 16))
                        .foregroundStyle(Color.black)
                    Spacer()
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Text("See all")
                            .font(.custom(.light, size: 16))
                            .foregroundStyle(Color.gray)
                    }
                }
                .padding(.horizontal)
                
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
                        
                        ForEach(store.state.playlistList.prefix(20)) {feed in
                            //   ForEach(1..<20) { repeatFeed in
                            PlaylistCell(playlist: feed)
                                .listRowSeparator(.hidden)
                            //  }
                        }
                    }
                    .padding(.horizontal, 8)
                    .listStyle(PlainListStyle())
                    
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            print("!!!!!!!!! --- Появился экран плейлиста --- !!!!!!!!")
            store.send(.viewAppered)
        }
        .background(Color.white)
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


#Preview {
    PlaylistView()
}
