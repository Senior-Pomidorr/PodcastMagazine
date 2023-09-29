//
//  PodcastElement.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//

import LoadableImage
import SwiftUI
import Models

struct PodcastElement: View {
//    private let mocItem: Feed = Feed.sample
    var item: Feed
    
    init(
        item: Feed
    ) {
        self.item = item
    }
    
    var body: some View {
        LoadableImage(item.image ?? "") { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .overlay {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.custom(.medium, size: 14))
                    .foregroundStyle(.white)
            }
            .font(.caption)
            .padding(.horizontal, 4)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 5)
        }
        
        
//        RoundedRectangle(cornerRadius: 12)
//            .fill(Color.orange)
//            .overlay {
//                LoadableImage(item.image ?? "") { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                }
//            }
//            .overlay {
//                VStack(alignment: .leading) {
//                    Text(item.title)
//                        .font(.custom(.medium, size: 14))
//                        .foregroundStyle(.white)
//                }
//                .font(.caption)
//                .padding(.horizontal, 4)
//            }
    }
}


struct PodcastElement_Previews: PreviewProvider {
    static var previews: some View {
        PodcastElement(item: Feed.sample)
            .previewLayout(.sizeThatFits)
    }
}
