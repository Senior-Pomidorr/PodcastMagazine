//
//  RealmError.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation

public extension RealmManager {
    enum RealmError: Error, LocalizedError {
        case missingValue
    }
}
