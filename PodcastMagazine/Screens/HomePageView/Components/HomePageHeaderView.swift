//
//  HomePageHeaderView.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 26.09.23.
//

import SwiftUI
import Models
import LoadableImage

struct HomePageHeaderView: View {
    
    var user: UserAccount
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if user.firstName != "" && user.lastName != "" {
                    Text(user.firstName + " " + user.lastName)
                        .font(.custom(.bold, size: 16))
                        .foregroundStyle(Color.black)
                    Text(user.email)
                        .font(.custom(.light, size: 14))
                        .foregroundStyle(Color.gray)
                } else {
                    Text("No user name")
                        .font(.custom(.bold, size: 16))
                        .foregroundStyle(Color.black)
                    Text("No user email")
                        .font(.custom(.light, size: 14))
                        .foregroundStyle(Color.gray)
                }
            }
            Spacer()
            
            LoadableImage(user.imageUrl ?? "https://random.imagecdn.app/150/150") { image in
                image
                    .resizable()
            }
            .frame(width: 48, height: 48)
            .foregroundStyle(Color.color1)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            .clipShape(RoundedRectangle(cornerRadius: 12))

        }
    }
}

#Preview {
    HomePageView()
}
