//
//  SearchBarView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 26.09.23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Podcast, channel, or artists", text: $searchText)
                .autocorrectionDisabled(true)
                .keyboardType(.webSearch)
                .foregroundColor(Color.searchBarText)
            
            Image(systemName: searchText.isEmpty ? "magnifyingglass" : "xmark.square")
                .foregroundColor(Color.secondaryText)
                .font(.title2)
                .onTapGesture {
                    searchText = ""
                }
            
        }
        .font(.body)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant("Podlodka"))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

