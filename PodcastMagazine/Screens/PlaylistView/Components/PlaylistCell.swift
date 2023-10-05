//
//  PlaylistCell.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI

struct PlaylistCell: View {
    var image: Image?
    var namePodcast: String
    var partPodcast: String
    
    var body: some View {
        HStack(alignment: .center) {
            Rectangle()
                .foregroundColor(Color("tintGray0"))
                .frame(width: 48, height: 48)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(namePodcast)
                    .font(.custom(.bold, size: 14))
                Text(partPodcast)
                    .font(.custom(.regular, size: 12))
                    .foregroundStyle(Color("GreyTextColor"))
            }
            .padding(.leading, 12)
        }
    }
}

#Preview {
    PlaylistCell(namePodcast: "Author Title", partPodcast: "Episodes")
}
