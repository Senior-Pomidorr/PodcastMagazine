//
//  AccountSettingsView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var store: AccountStore
    @AppStorage("tabBar") var hideTabBar = false
    @State private var showImage: Bool = false
    @State private var showSetImage: Bool = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @State private var birthDate = Date.now
    @State private var image = UIImage()
        
    //MARK: - Body
    var body: some View {
        ZStack {
            profileView
                .padding(.horizontal, 24)
            if showImage {
                scaledImage
            }
            if showSetImage {
                setImage
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(selectedImage: $image, sourceType: .camera)
                .ignoresSafeArea()
        }
    }
    
    //MARK: - ACCOUNT VIEW
    var profileView: some View {
        ZStack {
            VStack {
                AccountHeaderView()
                
                ScrollView {
                    ProfileImageSectionView(
                        image: image,
                        action: {
                            withAnimation {
                                showSetImage.toggle()
                            }
                        })
                    .onTapGesture {
                        withAnimation {
                            showImage.toggle()
                        }
                    }
                    CustomTextField(
                        title: "First name",
                        placeholder: "ex: Abigael",
                        text: bindName()
                    )
                    CustomTextField(
                        title: "Last Name",
                        placeholder: "ex: Amaniah",
                        text: bindLastName()
                    )
                    CustomTextField(
                        title: "E-mail",
                        placeholder: "ex: Amaniah@mail.com",
                        text: bindEmail()
                    )
                    
                    DatePickerView(birthDate: $birthDate)
                    
                    GenderSectionView(selectedGender: bindGender())
                }
            }
            VStack {
                Spacer()
                SaveButtonView()
            }
        }
    }
    
    var setImage: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showSetImage = false
                    }
                }
            
            VStack(spacing: 20) {
                
                Text("Change your picture")
                    .font(.headline)
                
                Divider()
                
                Button(action: {
                    withAnimation {
                        isShowCamera.toggle()
                        showSetImage = false
                    }
                }, label: {
                    HStack(spacing: 30) {
                        Image(systemName: "camera.fill")
                        Text("Take a photo")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.tintGray1.opacity(0.5))
                    )
                })
                Button(action: {
                    withAnimation {
                        isShowPhotoLibrary.toggle()
                        showSetImage = false
                    }
                }, label: {
                    HStack(spacing: 30) {
                        Image(systemName: "folder.fill")
                        Text("Choose from your file")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.tintGray1.opacity(0.5))
                    )
                })
                Button(action: {
                    
                    showSetImage = false
                    image = UIImage()
                    
                }, label: {
                    HStack(spacing: 30) {
                        Image(systemName: "trash.fill")
                        Text("Delete Photo")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.tintGray1.opacity(0.5))
                    )
                })
            }
            .foregroundColor(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
            )
            .padding()
        }
        .background(.ultraThinMaterial)
    }
    
    var scaledImage: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.bouncy) {
                        showImage = false
                    }
                }
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
            }
            .frame(width: 300, height: 300)
            .background(Color.purple)
            .clipShape(.rect(cornerRadius: 30))
        }
        .background(.ultraThinMaterial)
    }
    
    init(store: AccountStore = AccountDomain.previewStore) {
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
    
    func bindBirthDate() -> Binding<String> {
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
    AccountSettingsView(store: AccountDomain.previewStore)
}
