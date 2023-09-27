//
//  AccountSettingsView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var store: ProfileStore
    
    //MARK: - Body
    var body: some View {
        VStack {
            AccountHeaderView()
            ProfileImageSectionView(url: "https://loremflickr.com/cache/resized/65535_52661697260_0d20d6fed2_320_240_nofilter.jpg")
            CustomTextField(
                title: "First name",
                placeholder: "enter first name",
                text: bindName()
            )
            CustomTextField(
                title: "Last Name",
                placeholder: "enter last name",
                text: bindLastName()
            )
            CustomTextField(
                title: "E-mail",
                placeholder: "enter email",
                text: bindEmail()
            )
//            CustomTextField(
//                title: "Date of Birth",
//                placeholder: "enter date",
//                text: bindBirthDate()
//            )
            GenderSectionView(selectedGender: bindGender())
            Spacer()
            SaveButtonView()
//                .background(store.state.buttonIsActive
//                            ? .blue
//                            : .gray
//                )
        }
        .padding(.horizontal, 24)
        .navigationBarHidden(true)
    }
    
    init(store: ProfileStore = ProfileDomain.previewStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
    //MARK: - Bindings
    func bindName() -> Binding<String> {
        .init(
            get: { store.state.name },
            set: { store.send(.setFirstName($0)) }
        )
    }
    
    func bindLastName() -> Binding<String> {
        .init(
            get: { store.state.lastName },
            set: { store.send(.setLastName($0)) }
        )
    }
    
    func bindEmail() -> Binding<String> {
        .init(
            get: { store.state.email },
            set: { store.send(.setEmail($0)) }
        )
    }
    
    func bindBirthDate() -> Binding<Date> {
        .init(
            get: { store.state.dateOfBirth },
            set: { store.send(.setDateOfBirth($0)) }
        )
    }
    
    func bindGender() -> Binding<User.Gender> {
        .init(
            get: { store.state.gender },
            set: { store.send(.setGender($0)) }
        )
    }
}


#Preview {
    AccountSettingsView(store: ProfileDomain.previewStore)
}





