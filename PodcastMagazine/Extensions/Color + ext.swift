//
//  Color + ext.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 01.10.23.
//

import SwiftUI

extension Color {
    static func randomColorForItem() -> Color {
        let colors: [Color] = [
            .azure1, .azure2, .beige1, .beige2,
            .beige3, .beige4, .lilac1, .lilac2
        ]
        return colors.randomElement()!
    }
}
