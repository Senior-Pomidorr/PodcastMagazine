//
//  ProfileImageSectionView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct ProfileImageSectionView: View {
    
    let image: UIImage
    let action: () -> Void
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .background(Color.purple)
            .clipShape(Circle())
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    action()
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
    ProfileImageSectionView(image: UIImage(systemName: "heart")!, action: {})
}
