//
//  PodcastElement.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 27.09.23.
//

import SwiftUI
import Models

struct PodcastElement: View {
    let mocItem: Feed = Feed.sample
    var item: Feed?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.orange)
            .overlay {
                VStack(alignment: .leading) {
                    Text(mocItem.title)
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
        PodcastElement()
            .previewLayout(.sizeThatFits)
    }
}
