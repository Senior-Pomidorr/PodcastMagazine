//
//  SliderStack.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 06.10.2023.
//

import SwiftUI

struct SliderStack: View {
    @State var startTime: String
    @State var timeLeft: String
    @State var value: Double
    @State var duration: Double
    
    
    var body: some View {
        HStack {
            Text(startTime)
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
            Slider(value: $value, in: 0...duration)
                .padding()
            Text(timeLeft)
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
        }
        .padding(.horizontal, 48)
        .padding(.top, 38)
    }
}

#Preview {
    SliderStack(startTime: "", timeLeft: "", value: 0, duration: 3)
}
