//
//  SliderStack.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 06.10.2023.
//

import SwiftUI

struct SliderStack: View {
    var sliderValue: Binding<TimeInterval>
    @Binding var isEditing: Bool
    var duration: TimeInterval
    
    @State var startTime: String
    @State var timeLeft: String
    
    
    var body: some View {
        HStack {
            Text(startTime)
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
            
            Slider(
                value: sliderValue,
                in: 0...duration
            ) { editing in
                isEditing = editing
            }
            .padding()
            
            Text(timeLeft)
                .foregroundStyle(Color("mainText"))
                .font(.custom(.regular, size: 14))
        }
        .padding(.horizontal, 48)
        .padding(.top, 38)
    }
}
//
//#Preview {
//    SliderStack(startTime: "", timeLeft: "", value: 0, duration: 3)
//}
