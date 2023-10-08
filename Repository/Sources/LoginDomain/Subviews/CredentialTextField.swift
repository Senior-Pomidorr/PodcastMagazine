//
//  CredentialTextField.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import SwiftUI

struct CredentialTextField: View {
    private struct Drawing {
        static let textFieldHeight: CGFloat = 55
        static let animationDuration: Double = 0.2
        static let contentSpacing: CGFloat = 0
        static let backgroundOpacity: Double = 0.1
        static let cornerRadius: CGFloat = 12
    }
    
    let label: String
    let placeholder: String
    @Binding var text: String
    @State var isSecure = false
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Drawing.contentSpacing
        ) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.gray)
            HStack {
                Group {
                    switch isSecure {
                    case true:
                        SecureField(placeholder, text: $text)
                        
                    case false:
                        TextField(placeholder, text: $text)
                    }
                }
                .frame(height: Drawing.textFieldHeight)
                .textContentType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .animation(
                    .easeInOut(duration: Drawing.animationDuration),
                    value: isSecure
                )
                Button {
                    isSecure.toggle()
                } label: {
                   Image(systemName: isSecure ? "eye.slash" : "eye")
                        .tint(Color.gray)
                }
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(Drawing.backgroundOpacity))
            .clipShape(RoundedRectangle(cornerRadius: Drawing.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                    .stroke(Color.gray)
            }
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
