//
//  Playlist.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI

struct Playlist: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("Favorites")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Text("See all")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.horizontal, 28)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FavoritesCell()
                    FavoritesCell()
                    FavoritesCell()
                    FavoritesCell()
                    FavoritesCell()
                    FavoritesCell()
                }
            }
        }
    }
}


#Preview {
    Playlist()
}
