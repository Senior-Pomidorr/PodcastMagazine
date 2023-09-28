//
//  PodcastElement.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//

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
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.orange)
            .overlay {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.body)
//                    Text(mocItem.categories.first!.name)
//                    Text(mocItem.medium.rawValue)
                }
                .font(.caption)
                .padding(.horizontal, 4)
            }
    }
}


struct PodcastElement_Previews: PreviewProvider {
    static var previews: some View {
        PodcastElement(item: Feed.sample)
            .previewLayout(.sizeThatFits)
    }
}
