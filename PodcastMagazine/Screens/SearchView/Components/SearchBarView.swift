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
            TextField("", text: $searchText)
                .placeHolder(
                    Text("Podcast, channel, or artists")
                        .foregroundStyle(Color.secondaryText)
                    ,
                    show: searchText.isEmpty
                )
                .font(.custom(.medium, size: 14))
                .foregroundStyle(.searchBarText)
                .autocorrectionDisabled(true)
                .keyboardType(.webSearch)
                .submitLabel(.done)
                .frame(height: 21)
                .padding(.vertical, 14)
                .padding(.leading, 24)
            
            Image(
                searchText.isEmpty ? "magnifyingglass" : "xmarkSquare",
                bundle: nil
            )
            .foregroundStyle(.secondaryText)
            .frame(width: 24, height: 24)
            .padding(.vertical, 12)
            .padding(.trailing, 24)
            .onTapGesture {
                searchText = ""
            }
        }
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

struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}
