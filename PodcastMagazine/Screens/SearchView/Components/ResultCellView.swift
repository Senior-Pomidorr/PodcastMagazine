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
                isResultCell
                ? .clear
                : Color.azure1
            )
            .overlay {
                HStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            isResultCell
                            ? .tintBlue2
                            : .tintBlue1
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
                            TextView(
                                text: item.medium?.rawValue,
                                default: "20.02",
                                size: isResultCell ? 14 : 12,
                                style: CustomFont.light,
                                color: .tintGray3
                            )
                            
                            Text(
                                isResultCell
                                ? "|"
                                : "•"
                            )
                            .foregroundStyle(
                                isResultCell
                                ? .tintGray0
                                : .tintGray2
                            )
                            
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
}

#Preview {
    ResultCellView(
        isResultCell: true,
        item: Feed.sample
    )
}
