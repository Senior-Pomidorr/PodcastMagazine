//
//  SliderStack.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 06.10.2023.
//

import SwiftUI

struct SliderStack: View {
    var value: Binding<TimeInterval>
    var duration: TimeInterval
    var timeLeft: TimeInterval
    
    var body: some View {
        HStack {
            Text(DateComponentsFormatter.positional.string(from: value.wrappedValue) ?? "0:00")
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
            Slider(
                value: value,
                in: 0...duration
            )
            .padding()
            
            Text(DateComponentsFormatter.positional.string(from: timeLeft) ?? "0:00")
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
        }
        .padding(.horizontal, 48)
        .padding(.top, 38)
    }
}
