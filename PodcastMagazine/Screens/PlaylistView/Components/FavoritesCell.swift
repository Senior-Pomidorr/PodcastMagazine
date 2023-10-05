//
//  FavoritesCell.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI
import Models
import LoadableImage

struct FavoritesCell: View {
    var feed: Feed
//    private var ColourGenre = Color.blue
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("tintBlue"))
                    .frame(width: 120, height: 160)
                    .cornerRadius(16)
                VStack(spacing: 6) {
                    LoadableImage(feed.image ?? "No image") { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }
                    .foregroundColor(Color("tintGray1"))
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    
                    Text(feed.title)
                        .font(.custom(.bold, size: 14))
//                        .padding(.top, 6)
                        .frame(width: 120)
                        .multilineTextAlignment(.center)
                    Text(feed.author ?? "unknown")
                        .font(.custom(.regular, size: 12))
                        .foregroundStyle(Color("GreyTextColor"))
                }
            }
        }
    }
}

#Preview {
    FavoritesCell(feed: Feed.sample)
}
