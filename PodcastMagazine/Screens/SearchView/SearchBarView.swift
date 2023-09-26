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
                .foregroundColor(Color.searchBarText)
            
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(Color.secondaryText)
                .opacity(searchText.isEmpty ? 1.0 : 0.0)
            
        }
        .font(.body)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding()
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

