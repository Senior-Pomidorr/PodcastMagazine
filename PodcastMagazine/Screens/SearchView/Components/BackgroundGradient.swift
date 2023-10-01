//
//  BackgroundGradient.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 01.10.23.
//

import SwiftUI

struct BackgroundGradient: View {
    let frameBeigeCircle: CGFloat = 260
    let frameBlueCircle: CGFloat = 280
    
    struct BlurRadius {
        static let low: CGFloat = 100
        static let high: CGFloat = 150
    }
    
    
    var body: some View {
        ZStack {
            Group {
                Circle()
                    .fill(Color.beigeTintOpacityBack)
                    .blur(radius: BlurRadius.low)
                    .frame(height: frameBeigeCircle)
                    .offset(x: -150, y: -320)
                
                Circle()
                    .fill(Color.blueTintBack)
                    .blur(radius: BlurRadius.high)
                    .frame(height: frameBlueCircle)
                    .offset(x: 150, y: -400)
            }
            
            Group {
                Circle()
                    .fill(Color.beigeTintOpacityBack)
                    .blur(radius: BlurRadius.low)
                    .frame(height: frameBeigeCircle)
                    .offset(x: -150, y: 400)
                
                Circle()
                    .fill(Color.blueTintBack)
                    .blur(radius: BlurRadius.high)
                    .frame(height: frameBlueCircle)
                    .offset(x: 150, y: 350)
            }
        }
    }
}

#Preview {
    BackgroundGradient()
}
