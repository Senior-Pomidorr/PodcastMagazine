//
//  ProfileSettingsRowView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct ProfileSettingsRowView: View {
    
    let image: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: image)
                .frame(width: 48, height: 48)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 18, weight: .thin))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    ProfileSettingsRowView(image: "heart.fill", title: "New Title")
}
