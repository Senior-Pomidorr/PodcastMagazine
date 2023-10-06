//
//  AlbumImage.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 06.10.2023.
//

import SwiftUI
import LoadableImage

struct AlbumImage: View {
    var geometry: GeometryProxy
    var body: some View {
        Spacer()
        LoadableImage("https://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11") { image in
            image
                .resizable()
                .scaledToFill()
        }
            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.50)
            .background(Color("tintBlue2"))
            .cornerRadius(16)
            .shadow(radius: 8)
        Spacer()
    }
}

//#Preview {
//    AlbumImage(geometry: .constant()
//}
