//
//  CreatePlaylistView.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI

struct CreatePlaylistView: View {
    @State private var newPlaylistName = ""
    @State var searchFieldText: String = ""
    
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                    .padding(.top, 24)
                    
                    Rectangle()
                        .frame(height: 1) // Высота линии
                        .foregroundColor(Color("Grey"))
                        .padding(.top, 8)
                        .padding(.horizontal, 32)
                    
                    SearchBarCreatePlaylist(searchTextPlaylist: $searchFieldText)
                        .padding(.vertical, 24)
                    VStack(spacing: 16) {
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                        CreatePlaylistCells()
                    }
                }
            }
        }
        .navigationTitle("Create playlist")
    }
}

#Preview {
    CreatePlaylistView()
}
