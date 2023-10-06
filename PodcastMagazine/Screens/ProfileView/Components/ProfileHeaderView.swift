//
//  ProfileHeaderView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI
import Repository
import Models
import LoadableImage

struct ProfileHeaderView: View {
    
    let user: UserAccount
    
    var body: some View {
        HStack(spacing: 16) {
            LoadableImage(user.imageUrl ?? "", scale: 1) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 48, height: 48)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 10, y: 13)
            
            VStack(alignment: .leading) {
                Text(user.firstName + " " + user.lastName)
                    .font(.custom(.bold, size: 16))
                    .foregroundStyle(Color.black)
                Text("Love,life and chill")
                    .font(.custom(.light, size: 14))
                    .foregroundStyle(Color.gray)
            }
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ProfileHeaderView(user: UserAccount.init(firstName: "Abigael", lastName: "Amaniah", email: "124124@gmail.com"))
}
