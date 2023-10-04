//
//  ProfileSettingsView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @StateObject var store = ProfileStore(
        state: ProfileDomain.State(dataLoadingStatus: .none),
        reducer: ProfileDomain.live.reduce(_:with:))
    
    let url: String = "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg"
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 21) {
                    
                    ProfileHeaderView(url: url)
                        .padding(.bottom)
                    
                    NavigationLink {
                        AccountSettingsView(store: ProfileDomain.previewStore)
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
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Log Out")
                            .padding()
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(24)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                    })
                    .padding(.bottom)
                }
                .tint(.black)
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
