//
//  SearchBarView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 26.09.23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var queryText: String
    
    var body: some View {
        HStack {
            TextField("", text: $queryText)
                .placeHolder(
                    Text("podcast, channel, or artists")
                        .foregroundStyle(Color.tintGray3)
                    ,
                    show: queryText.isEmpty
                )
                .font(.custom(.medium, size: 14))
                .foregroundStyle(.mainText)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                .keyboardType(.webSearch)
                .submitLabel(.done)
                .frame(height: 21)
                .padding(.vertical, 14)
                .padding(.leading, 24)
            
            Image(
                queryText.isEmpty ? "magnifyingglass" : "xmarkSquare",
                bundle: nil
            )
            .foregroundStyle(.tintGray3)
            .frame(width: 24, height: 24)
            .padding(.vertical, 12)
            .padding(.trailing, 24)
            .onTapGesture {
                queryText = ""
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
        SearchBarView(queryText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        SearchBarView(queryText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

// MARK: - PlaceHolder
/// struct Для расширения View.
/// По сути рисует  view поверх другова view
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
