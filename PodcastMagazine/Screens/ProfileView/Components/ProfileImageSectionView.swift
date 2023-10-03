//
//  ProfileImageSectionView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct ProfileImageSectionView: View {
    let url: String

    var body: some View {
        AsyncImage(
            url: URL(string: url)
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure(let error):
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.6)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 100, height: 100)
        .background(Color.purple)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                // Action for editing profile image goes here
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            .frame(width: 32, height: 32)
        }
    }
}

#Preview {
    ProfileImageSectionView(url: "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg")
}
