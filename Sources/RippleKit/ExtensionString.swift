//
//  ExtensionString.swift
//  
//
//  Created by Edoardo Benissimo on 26/07/22.
//

import Foundation

extension String {
    var fullRange: NSRange {
        return NSMakeRange(0, NSString(string: self).length)
    }
    func contains(word: String) -> Bool {
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}
