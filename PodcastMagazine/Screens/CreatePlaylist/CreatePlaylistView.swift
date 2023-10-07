//
//  CreatePlaylistView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI
import Repository

struct CreatePlaylistView: View {
    @StateObject var store: CreatePlaylistStore = CreatePlaylistDomain.createPlaylistLive
    @State private var newPlaylistName = ""
    @State var searchFieldText: String = ""
    @State var isTapped: Bool = false
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        Button {
                            isShowPhotoLibrary = true
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
                            ForEach(store.state.getEpisodesRequest) {feed in
                                VStack(spacing: 16) {
                                    CreatePlaylistCells(isTapped: isTapped, image: feed.image, title: feed.title, author: feed.feedTitle ?? "No feed title")
                                }
                            }
                                                  
                        case let .error(error):
                            Text(String(describing: error))
                        case .loading:
                            ProgressView()
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
        .toolbar {
            AddPlaylistButton()
        }
        .frame(alignment: .trailing)
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CreatePlaylistView()
}
