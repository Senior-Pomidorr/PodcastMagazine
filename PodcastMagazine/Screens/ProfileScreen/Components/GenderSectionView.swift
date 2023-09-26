//
//  GenderSectionView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 26.09.2023.
//

import SwiftUI

struct GenderSectionView: View {
    
    @Binding var selectedGender: Gender
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Gender")
                .foregroundStyle(.gray)
            
            HStack {
                Button(action: {
                    selectedGender = .male
                }) {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: selectedGender == .male ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(selectedGender == .male ? .blue : .gray)
                                Spacer()
                            }
                            Text("Male")
                        }
                    }
                    .padding()
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(lineWidth: 1)
                    )
                }
                
                Button(action: {
                    selectedGender = .female
                }) {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: selectedGender == .female ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(selectedGender == .female ? .blue : .gray)
                                Spacer()
                            }
                            Text("Female")
                        }
                    }
                    .padding()
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(lineWidth: 1)
                    )
                }
            }
        }

    }
}

#Preview {
    GenderSectionView(selectedGender: .constant(.male))
}
