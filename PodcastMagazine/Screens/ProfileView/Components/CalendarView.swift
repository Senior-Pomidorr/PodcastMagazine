//
//  DatePickerView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 06.10.2023.
//

import SwiftUI

struct CalendarView: View {

    @Binding var birthday: Date
    @State private var isChild = false
    @State private var ageFilter = ""

    var body: some View {

        Image(systemName: "calendar")
          .font(.title3)
          .foregroundColor(.accentColor)
          .overlay{
             DatePicker(
                 "",
                 selection: $birthday,
                 displayedComponents: [.date]
             )
              .blendMode(.destinationOver)
              .onChange(of: birthday, perform: { value in
                  isChild = checkAge(date:birthday)
               })
          }
    }

    func checkAge(date: Date) -> Bool  {
        let today = Date()
        let diffs = Calendar.current.dateComponents([.year], from: date, to: today)
        let formatter = DateComponentsFormatter()
        let outputString = formatter.string(from: diffs)
        self.ageFilter = outputString!.filter("0123456789.".contains)
        let ageTest = Int(self.ageFilter) ?? 0
        if ageTest > 18 {
            return false
        }else{
            return true
        }
    }
}

#Preview {
    CalendarView(birthday: .constant(.now))
}
