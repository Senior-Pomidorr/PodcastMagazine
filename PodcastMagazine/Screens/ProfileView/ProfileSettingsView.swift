//
//  ProfileSettingsView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI
import Models

struct ProfileSettingsView: View {
    
    @StateObject var store = AccountStore(
        state: AccountDomain.State(dataLoadingStatus: .none),
        reducer: AccountDomain.live.reduce(_:with:))
    
    let user: UserAccount = UserAccount.init(firstName: "Abigael", lastName: "Amaniah", email: "124124@gmail.com")
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 21) {
                    
                    ProfileHeaderView(user: user)
                        .padding(.bottom)
                    
                    NavigationLink {
                        AccountSettingsView(store: AccountDomain.previewStore)
                    } label: {
                        ProfileSettingsRowView(image: "person", title: "Account Settings")
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        ProfileSettingsRowView(image: "checkmark.shield", title: "Change Password")
                    }
                    NavigationLink {
                        
                    } label: {
                        ProfileSettingsRowView(image: "lock.open", title: "Forgot Password")
                    }
                    
                    Spacer()
                    
                    LogOutButton(action: { })
                }
                .tint(.black)
                .background(Color.white)
                .padding()
            }
        }
    }
}

#Preview {
    NavigationView {
        ProfileSettingsView()
    }
}

