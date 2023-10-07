//
//  SearchBarCreatePlaylist.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 27.09.2023.
//

import SwiftUI

struct SearchBarCreatePlaylist: View {
    @Binding var searchTextPlaylist: String
    var body: some View {
        HStack {
            TextField("Search...", text: $searchTextPlaylist)
                .foregroundColor(.black)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                .keyboardType(.webSearch)
//                .submitLabel(.done)
            Spacer()
            Image("Search")
                .offset(x: 10)
                .foregroundColor(Color.gray)
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .background(Color(red: 0.93, green: 0.94, blue: 0.99))
        .cornerRadius(12)
        .padding(.horizontal, 32)
    }
}

#Preview {
    SearchBarCreatePlaylist(searchTextPlaylist: .constant(""))
}
