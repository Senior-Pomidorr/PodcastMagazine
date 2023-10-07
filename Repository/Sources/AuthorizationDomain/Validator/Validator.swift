//
//  Validator.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation

struct Regex {
    static let leastOneUppercased = ".*[A-Z]+.*"
    static let leastOneDigit = ".*[0-9]+.*"
    static let leastOneLowercase = ".*[a-z]+.*"
}

public struct Validator {
    public static func validate(email: String) -> Bool {
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
    
    public static func validate(password: String) -> Bool {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            .init(format: .matchesPredicate, Regex.leastOneUppercased),
            .init(format: .matchesPredicate, Regex.leastOneDigit),
            .init(format: .matchesPredicate, Regex.leastOneLowercase)
        ])
        .evaluate(with: password)
    }
}
