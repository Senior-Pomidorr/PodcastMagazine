//
//  CreatePlaylistView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI

struct CreatePlaylistView: View {
    @StateObject var store: CreatePlaylistStore = CreatePlaylistDomain.createPlaylistLive
    @State private var newPlaylistName = ""
    @State var searchFieldText: String = ""
    @State var isTapped: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        Button {
                            
                        } label: {
                            ZStack {
                                Image("backgroundImage")
                                    .frame(width: 84, height: 84)
                                    .cornerRadius(16)
                                Image("mockImage")
                            }
                        }
                    }
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            TextField("Give a name for your playlist", text: $newPlaylistName)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("tintGray1"))
                            .padding(.top, 6)
                            .padding(.horizontal, 32)
                        
                        SearchBarCreatePlaylist(searchTextPlaylist: $searchFieldText)
                            .padding(.vertical, 18)
                        switch store.state.playlistStatus {
                        case .none:
                            ForEach(store.state.randomEpisodes) {feed in
                                VStack(spacing: 16) {
                                    CreatePlaylistCells(isTapped: isTapped, image: feed.image, title: feed.title, author: feed.description)
                                }
                            }
                            
//                            ForEach(store.state.getEpisodesRequest.prefix(20)) {feed in
//                                VStack(spacing: 16) {
//                                    CreatePlaylistCells(isTapped: isTapped, image: feed.image, title: feed.title, author: feed.description)
//                                }
                            
                        case let .error(error):
                            Text("Ошибка  - \(error.localizedDescription)")
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.top, 30)
        }
        .onAppear {
            store.send(.viewAppeared)
        }
        .navigationTitle("Create playlist")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    CreatePlaylistView()
}
