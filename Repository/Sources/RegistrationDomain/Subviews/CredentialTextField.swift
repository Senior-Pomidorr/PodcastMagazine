//
//  SwiftUIView.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import SwiftUI

struct CredentialTextField: View {
    private struct Drawing {
        static let contentSpacing: CGFloat = 5
        static let backgroundOpacity: Double = 0.1
        static let cornerRadius: CGFloat = 25
    }
    
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Drawing.contentSpacing
        ) {
            Text(label)
                .font(.callout)
                .foregroundStyle(Color.gray)
            TextField(
                placeholder,
                text: $text
            )
            .padding()
            .background(Color.blue.opacity(Drawing.backgroundOpacity))
            .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    CredentialTextField(
        label: "Label",
        placeholder: "Placeholder",
        text: .constant("")
    )
}
