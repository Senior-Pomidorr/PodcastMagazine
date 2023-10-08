//
//  ErrorPlayerView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 07.10.23.
//

import SwiftUI

struct ErrorPlayerView: View {
    var error: Error
    
    var body: some View {
        VStack {
            Text("\(error.localizedDescription)")
        }
        .navigationTitle("Error")
    }
}

//#Preview {
//    ErrorPlayerView()
//}
