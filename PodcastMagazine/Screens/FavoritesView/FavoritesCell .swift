//
//  FavoritesCell .swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 08.10.2023.
//

import SwiftUI
import Models
import LoadableImage

struct FavoritesCellForAll: View {
        var feed: Feed
        
        var body: some View {
            HStack(alignment: .center) {
                LoadableImage(feed.image ?? "No image") { image in
                    image
                        .resizable()
                        .scaledToFill()
                }
                    .foregroundColor(Color("tintGray0"))
                    .frame(width: 48, height: 48)
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 4) {
                    Text(feed.author ?? "")
                        .font(.custom(.bold, size: 14))
                    Text(feed.title)
                        .font(.custom(.regular, size: 12))
                        .foregroundStyle(Color("GreyTextColor"))
                }
                .padding(.leading, 12)
            }
        }
    }

#Preview {
    FavoritesCellForAll(feed: Feed.sample)
}
