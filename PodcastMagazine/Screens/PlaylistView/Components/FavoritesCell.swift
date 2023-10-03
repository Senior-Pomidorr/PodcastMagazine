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
                    .foregroundColor(Color("tintBlue2"))
                    .frame(width: 120, height: 160)
                    .cornerRadius(16)
                VStack {
                    Rectangle()
                        .foregroundColor(Color("tintBlue2"))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
//
                    Text("Baby Pesut")
                        .font(.system(size: 14))
                        .padding(.bottom, 4)
                        .padding(.top, 8)
                    Text("Dr. Oi om jean")
                        .font(.system(size: 12))
                        
                    
                }
              
            }
        }
    }
}

#Preview {
    FavoritesCell()
}
