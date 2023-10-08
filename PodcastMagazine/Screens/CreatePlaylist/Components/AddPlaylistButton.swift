//
//  AddPlaylistButton.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 07.10.2023.
//

import SwiftUI

struct AddPlaylistButton: View {
    var body: some View {
        Menu {
            Button("Добавить в избранное",
                   action: { print("Action 1 triggered") })
        } label: {
            Image("SettingsButton")
        }
    }
    
}

#Preview {
    AddPlaylistButton()
}
