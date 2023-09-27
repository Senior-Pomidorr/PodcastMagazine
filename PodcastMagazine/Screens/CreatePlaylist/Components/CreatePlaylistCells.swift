//
//  CreatePlaylistCells.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI

struct CreatePlaylistCells: View {
    @State private var isTapped = false
    //    private var podcastImage: UIImage
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 56, height: 56)
                .background(Color(red: 0.73, green: 0.9, blue: 0.91))
                .cornerRadius(16)
                .padding(8)
            VStack(alignment: .leading) {
                Text("Title")
                HStack {
                    Text("Author")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                    Text("1:40")
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
    CreatePlaylistCells()
}
