//
//  CustomTextField.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct CustomTextField: View {
    
    private var title: String
    private var placeholder: String
    private var text: Binding<String>
    
    init(title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundStyle(.gray)
            
            TextField(placeholder, text: text)
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .cornerRadius(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.blue)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CustomTextField(title: "Name", placeholder: "enter your name", text: .constant("asd"))
}
