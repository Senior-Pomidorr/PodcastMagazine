//
//  CustomBackButton.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 1.10.23.
//

import SwiftUI

struct CustomBackButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .imageScale(.small)
                .font(.callout)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    CustomBackButton()
}
