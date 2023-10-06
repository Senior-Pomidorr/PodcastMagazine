//
//  TextTitle.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 06.10.2023.
//

import SwiftUI

struct TextTitle: View {
    var episodeTitle: String
    var authorTitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(episodeTitle)
                .font(.custom(.bold, size: 16))
                .kerning(0.32)
            Text(authorTitle)
                .font(.custom(.regular, size: 14))
                .foregroundStyle(Color("GreyTextColor"))
                .padding(.top, 5)
        }
        .padding(.top, 36)
    }
}

#Preview {
    TextTitle(episodeTitle: "", authorTitle: "")
}
