//
//  ErrorView.swift
//
//
//  Created by Илья Шаповалов on 29.09.2023.
//

import SwiftUI

struct ErrorView: View {
    private let imageSize: CGFloat = 50
    let error: Error
    
    var body: some View {
        VStack {
            Image(systemName: "figure.fall.circle.fill")
                .resizable()
                .frame(
                    maxWidth: imageSize,
                    maxHeight: imageSize
                )
            Text(error.localizedDescription)
                .font(.callout)
        }
    }
}

#Preview {
    ErrorView(error: URLError(.badURL))
}
