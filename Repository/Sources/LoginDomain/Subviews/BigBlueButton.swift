//
//  BigBlueButton.swift
//  
//
//  Created by Илья Шаповалов on 08.10.2023.
//

import SwiftUI

struct BigBlueButton: View {
    private let cornerRadius: CGFloat = 28
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    BigBlueButton(title: "Title", action: {})
}
