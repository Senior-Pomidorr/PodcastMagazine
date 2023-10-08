//
//  LoadingPlayerView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 07.10.23.
//

import SwiftUI

struct LoadingPlayerView: View {
    var body: some View {
        VStack {
            ProgressView()
        }
        .navigationTitle("Now playing")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    LoadingPlayerView()
}
