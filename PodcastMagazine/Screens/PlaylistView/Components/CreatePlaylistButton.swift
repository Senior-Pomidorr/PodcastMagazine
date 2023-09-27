//
//  GreatePlaylistButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI

struct CreatePlaylistButton: View {
    var image: Image?
    
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("Grey"))
                    .frame(width: 48, height: 48)
                    .cornerRadius(8)
                Image(systemName: "plus")
            }
            Text("Create Playlist")
                .padding(.leading, 14)
        }
    }
}

#Preview {
    CreatePlaylistButton()
}
