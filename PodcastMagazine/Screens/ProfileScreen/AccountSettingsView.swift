//
//  AccountSettingsView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct AccountSettingsView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var dateOfBirth: Date = Date()
    @State var selectedGender: Gender = .none
    
    let url: String
    
    var body: some View {
        VStack {
            AccountHeaderView()
            ProfileImageSectionView(url: "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg")
            CustomTextField(title: "First name", placeholder: "enter first name", text: $firstName)
            CustomTextField(title: "Last Name", placeholder: "enter last name", text: $lastName)
            CustomTextField(title: "E-mail", placeholder: "enter email", text: $email)
            CustomTextField(title: "Date of Birth", placeholder: "enter date", text: $email)
            GenderSectionView(selectedGender: $selectedGender)
            Spacer()
            SaveButtonView()
        }
        .padding(.horizontal, 24)
        .navigationBarHidden(true)
    }
}


#Preview {
    AccountSettingsView(url: "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg")
}





