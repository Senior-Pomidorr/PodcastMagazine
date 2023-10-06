//
//  DatePickerView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 06.10.2023.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var birthDate: Date
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date of Birth")
                .foregroundStyle(.gray)
            
            HStack {
                Text(birthDate, formatter: dateFormatter)
                Spacer()
                CalendarView(birthday: $birthDate)
            }
            .padding()
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .cornerRadius(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.accentColor)
            )
        }
    }
}

#Preview {
    DatePickerView(birthDate: .constant(.now))
}
