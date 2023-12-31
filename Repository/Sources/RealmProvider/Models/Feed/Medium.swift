//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models
import RealmSwift

extension Medium: PersistableEnum {
    public static var allCases: [Medium] {
        var arr = [Medium]()
        arr.append(.audiobook)
        arr.append(.film)
        arr.append(.music)
        arr.append(.video)
        return arr
    }
}
