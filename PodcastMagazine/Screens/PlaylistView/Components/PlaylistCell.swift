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
                .foregroundColor(Color("Grey"))
                .frame(width: 48, height: 48)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(namePodcast)
                Text(partPodcast)
            }
            .padding(.leading, 12)
        }
//        .padding(.horizontal, 28)
    }
}

#Preview {
    PlaylistCell(namePodcast: "", partPodcast: "")
}
