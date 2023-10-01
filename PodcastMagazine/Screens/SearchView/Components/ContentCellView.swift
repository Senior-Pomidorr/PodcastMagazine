//
//  ContentCellView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 30.09.23.
//

import SwiftUI
import LoadableImage
import Models

struct ContentCellView: View {
    let item: Feed
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.azure1)
            .overlay {
                HStack {
                    LoadableImage(item.image ?? "") { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                    }
                    .frame(width: 56, height: 56)
                    
                    VStack(alignment: .leading) {
                        Text(item.title)
                        Text(item.author ?? "Uknow author")
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
    }
}

#Preview {
    ContentCellView(item: Feed.sample)
}
