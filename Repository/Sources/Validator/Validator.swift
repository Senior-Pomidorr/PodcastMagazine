//
//  Validator.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation

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
        guard password.count > 7 else {
            return false
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            .init(format: .matchesPredicate, Regex.uppercasedChar),
            .init(format: .matchesPredicate, Regex.digit),
            .init(format: .matchesPredicate, Regex.lowercasedChar),
            .init(format: .matchesPredicate, Regex.symbol)
        ])
        .evaluate(with: password)
    }
}

extension Validator {
    struct Regex {
        static let uppercasedChar = ".*[A-Z]+.*"
        static let digit = ".*[0-9]+.*"
        static let lowercasedChar = ".*[a-z]+.*"
        static let symbol = ".*[!&^%$#@()/]+.*"
    }
}
