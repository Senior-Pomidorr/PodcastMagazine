//
//  Date + Ext.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

/// `DateComponentsFormatter`
/// расширение для DateComponentsFormatter
/// пример использования:
///   ```Text(
///         DateComponentsFormatter
///         .positional.string(from: currentTime) ?? "0:00"
///      )
///  ```
extension DateComponentsFormatter {
    static let abbreviated: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        return formatter
    }()
    
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
}
