//
//  EmailValidator.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation

public struct EmailValidator {
    public static func validate(_ email: String) -> Bool {
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let rangeToValidate = NSRange(
            email.startIndex..<email.endIndex,
            in: email
        )
        
        let matches = emailDetector.matches(
            in: email,
            range: rangeToValidate
        )
        
        guard
            matches.count == 1,
            let singleMatch = matches.first,
            singleMatch.url?.scheme == "mailto"
        else {
            return false
        }
        
        return true
    }
}
