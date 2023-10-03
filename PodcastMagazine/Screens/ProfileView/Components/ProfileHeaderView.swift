//
//  ProfileHeaderView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct ProfileHeaderView: View {
    let url: String
    
    var body: some View {
        HStack(spacing: 16) {
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
            .frame(width: 48, height: 48)
            .background(Color.purple)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 10, y: 13)
            
            VStack(alignment: .leading) {
                Text("Abigael Amaniah")
                    .font(.headline)
                Text("Love, life and chill")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ProfileHeaderView(url: "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg")
}
