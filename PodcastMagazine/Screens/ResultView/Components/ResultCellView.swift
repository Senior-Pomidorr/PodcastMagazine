//
//  ContentCellView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 30.09.23.
//

import SwiftUI
import LoadableImage
import Models

struct ResultCellView: View {
    let isResultCell: Bool
    let item: Feed
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                isResultCell ? .clear : Color.color5.opacity(0.7)
            )
            .shadow(
                color: .black.opacity(isResultCell ? 0 : 0.1),
                radius: 3,
                x: 0,
                y: 5
            )
            .overlay {
                HStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isResultCell ? .tintBlue2 : .tintBlue1
                        )
                        .frame(width: 56, height: 56)
                        .overlay {
                            LoadableImage(item.image ?? "") { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                            }
                        }
                    
                    VStack(alignment: .leading) {
                        TextView(
                            text: item.title,
                            size: isResultCell ? 16 : 14,
                            style: CustomFont.bold
                        )
                        HStack {
                            // TODO: Временное решение if else, возможно поменяется запрос
                            if isResultCell {
                                
                                TextView(
                                    text: getEpisodCount(item.episodeCount),
                                    size: isResultCell ? 14 : 12,
                                    style: CustomFont.light,
                                    color: .tintGray3
                                )
                                
                                Text(
                                    isResultCell ? "|" : "•"
                                )
                                .foregroundStyle(
                                    isResultCell ? .tintGray0 : .tintGray2
                                )
                            }
                            
                            TextView(
                                text: item.author,
                                default: "Uknow author",
                                size: isResultCell ? 14 : 12,
                                style: CustomFont.light,
                                color: .tintGray5
                            )
                        }
                    }
                    .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
    }
    
    func getEpisodCount(_ count: Int?) -> String? {
        if let count {
            return String(count)
        }
        return nil
    }
}

#Preview {
    ResultCellView(
        isResultCell: true,
        item: Feed.sample
    )
}
