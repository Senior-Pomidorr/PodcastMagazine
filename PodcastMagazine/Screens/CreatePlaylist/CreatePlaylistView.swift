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
                        switch store.state.createPlaylistStatus {
                        case .none:
                            VStack(spacing: 16) {
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                                CreatePlaylistCells()
                            }
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding(.top, 30)
        }
        .navigationTitle("Create playlist")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    CreatePlaylistView()
}
