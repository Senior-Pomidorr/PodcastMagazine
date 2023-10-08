//
//  FavoritesView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 05.10.2023.
//

import SwiftUI
import Models

struct FavoritesView: View {
    @StateObject var store: PlaylistStore = PlayListDomain.playlistDomainLive
    var mockFeed: [Feed] = [Feed.sample]
    var body: some View {
        NavigationView {
            switch store.state.playlistStatus {
            case .none:
            List {
                ForEach(store.state.favoritesList) {item in
                    FavoritesCellForAll(feed: item)
                            .listRowSeparator(.hidden)
                    }
                }
            .listStyle(PlainListStyle())
                default:
                    EmptyView()
                }
            }
        .onAppear {
            store.send(.viewAppered)
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
