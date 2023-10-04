//
//  ShuffleButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI

struct ShuffleButton: View {
    var body: some View {
        Button {
            print("shuffle tap")
        } label: {
            Image("shuffle")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
    }
}

#Preview {
    ShuffleButton()
}
