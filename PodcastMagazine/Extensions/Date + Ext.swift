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
