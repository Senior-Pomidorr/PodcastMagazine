//
//  Font+Extension.swift
//  PodcastMagazine
//
//  Created by Alexandr Rodionov on 27.09.23.
//

import Foundation
import SwiftUI

extension Font {
    static func custom(_ font: CustomFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, size: size)
    }
}
