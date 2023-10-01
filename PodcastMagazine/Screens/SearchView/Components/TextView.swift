//
//  TextView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 01.10.23.
//

import SwiftUI

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
        text: String?,
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
