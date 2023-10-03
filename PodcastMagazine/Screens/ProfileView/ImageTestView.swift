//
//  ImageTestView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import SwiftUI

struct ImageTestView: View {

    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()

    var body: some View {
        VStack {

            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))

                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
        }
    }
}

#Preview {
    ImageTestView()
}
