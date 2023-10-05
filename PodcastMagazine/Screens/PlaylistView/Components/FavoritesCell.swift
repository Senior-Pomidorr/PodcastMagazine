//
//  FavoritesCell.swift
//  PodcastMagazine
//
//  Created by Daniil Kulikovskiy on 26.09.2023.
//

import SwiftUI

struct FavoritesCell: View {
    private var ColourGenre = Color.blue
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("tintBlue"))
                    .frame(width: 120, height: 160)
                    .cornerRadius(16)
                VStack(spacing: 6) {
                    Rectangle()
                        .foregroundColor(Color("tintGray1"))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
//
                    Text("Baby Pesut")
                        .font(.custom(.bold, size: 14))
                        .padding(.top, 6)
                    Text("Dr. Oi om jean")
                        .font(.custom(.regular, size: 12))
                        .foregroundStyle(Color("GreyTextColor"))
                       
                    
                }
              
            }
        }
    }
}

#Preview {
    FavoritesCell()
}
