//
//  SkipButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 29.09.2023.
//

import SwiftUI

struct SkipButton: View {
    @Binding var skipScreen: Int
    
    var body: some View {
        Button {
            skipScreen = 0
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 85, height: 58)
                    .foregroundColor(.clear)
                    .cornerRadius(20)
                Text("Skip")
                    .foregroundStyle(.black)
                    .font(.system(size: 24))
//                    .font(.weight(.semibold))
            }
        }
    }
}


#Preview {
    SkipButton(skipScreen: .constant(0))
}
