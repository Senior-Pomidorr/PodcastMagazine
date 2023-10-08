//
//  CreatePlaylistCells.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI
import LoadableImage

struct CreatePlaylistCells: View {
    @State var isTapped = false
    @State var image: String
    @State var title: String
    @State var author: String
    
    var body: some View {
        HStack {
            LoadableImage(image) { image in
                image
                    .resizable()
                    .scaledToFill()
            }
                .foregroundColor(.clear)
                .frame(width: 56, height: 56)
                .background(Color(red: 0.73, green: 0.9, blue: 0.91))
                .cornerRadius(16)
                .padding(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom(.bold, size: 14))
                HStack {
                    Text(author)
                        .font(.custom(.regular, size: 12))
                    Image(systemName: "circle.fill")
                        .font(.custom(.regular, size: 6))
                    Text("1:40")
                        .font(.custom(.regular, size: 12))
                }
                .foregroundColor(Color(red: 0.64, green: 0.63, blue: 0.69))
            }
            Spacer()
            Button {
                isTapped.toggle()
            } label: {
                isTapped ? Image("Tap") : Image("Plus")
            }
            .padding(.trailing, 26)
        }
        .frame( height: 72)
        .background(Color(red: 0.93, green: 0.94, blue: 0.99))
        .cornerRadius(16)
        .padding(.horizontal, 32)
    }
}

#Preview {
    CreatePlaylistCells(isTapped: false, image: "", title: "Title", author: "Author")
}
