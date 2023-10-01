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
                            item.title,
                            size: isResultCell ? 16 : 14,
                            style: CustomFont.bold
                        )
                        HStack {
                            TextView(
                                item.medium?.rawValue,
                                default: "20.02",
                                size: isResultCell ? 14 : 12,
                                style: CustomFont.light,
                                color: .tintGrey3
                            )
                            
                            Text(
                                isResultCell
                                ? "|"
                                : "•"
                            )
                            .foregroundStyle(
                                isResultCell
                                ? .tintGrey0
                                : .tintGrey2
                            )
                            
                            TextView(
                                item.author,
                                default: "Uknow author",
                                size: isResultCell ? 14 : 12,
                                style: CustomFont.light,
                                color: .tintGrey5
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


/// - Parameters:
///   - size: default = 14
///   - style: default value - CustomFont = .medium
///   - color: default value - .mainText
struct TextView: View {
    var text: String?
    var defaultText: String
    let size: CGFloat
    let style: CustomFont
    let color: Color

    init(
        _ text: String?,
        default defaultText: String = .init(),
        size: CGFloat = 14,
        style: CustomFont = .medium,
        color: Color = .mainText
    ) {
        self.text = text
        self.defaultText = defaultText
        self.size = size
        self.style = style
        self.color = color
    }
    
    var body: some View {
        Text(text ?? defaultText)
            .foregroundStyle(color)
            .font(.custom(style, size: size))
    }
}
