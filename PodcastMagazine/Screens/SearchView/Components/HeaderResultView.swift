//
//  HeaderResultView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 28.09.23.
//

import SwiftUI

struct HeaderResultView: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                TextView(text: title)
                
                Spacer()
                
                // элемент с крестиком вместо кнопки back в NavigationBar
                Image("xmarkSquare", bundle: nil)
                    .foregroundStyle(.tintGray3)
                    .frame(width: 24, height: 24)
                    .offset(x: -24)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding(.horizontal, 33)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.divider)
                .padding(.horizontal, 33)
        }
    }
}

struct HeaderResultView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderResultView(title: "Podlodka")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
