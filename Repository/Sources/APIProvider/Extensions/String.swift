//
//  String.swift
//
//
//  Created by Илья Шаповалов on 25.09.2023.
//

import Foundation
import CommonCrypto

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](
            repeating: 0,
            count: Int(CC_SHA1_DIGEST_LENGTH)
        )
        data.withUnsafeBytes { unsafeRawBufferPointer in
            _ = CC_SHA1(
                unsafeRawBufferPointer.baseAddress,
                CC_LONG(data.count),
                &digest
            )
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    var currentTime: String {
        .init(Int(Date().timeIntervalSince1970))
    }
}
