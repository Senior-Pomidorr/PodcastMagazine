//
//  View + Ext.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import SwiftUI

extension View {
    func fadeOutBottom(fadeLength:CGFloat=50) -> some View {
        return mask(
            VStack(spacing: 0) {
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient:
                                Gradient(
                                    colors: [Color.black.opacity(0), Color.black]),
                               startPoint: .bottom, endPoint: .top
                )
                .frame(height: fadeLength)
            }
        )
    }
}
