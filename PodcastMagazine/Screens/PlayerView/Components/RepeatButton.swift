//
//  RepeatButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 04.10.2023.
//

import SwiftUI

struct RepeatButton: View {
    var body: some View {
        Button {
            print("shuffle tap")
        } label: {
            Image("repeat")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
    }
}

#Preview {
    RepeatButton()
}
