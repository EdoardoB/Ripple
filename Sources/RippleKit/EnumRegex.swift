//
//  EnumRegex.swift
//  
//
//  Created by Edoardo Benissimo on 26/07/22.
//

import Foundation

enum SearchRegex: String {
    case localizedKey = "\"(.*?)\"(?:\\s*=)"
    case plistKey = "<key>(.*?)</key>"
    case plistString = "<string>(.*?)</string>"
    case xibText = "text=\"(.*?)\""
    case xibButton = "buttonConfiguration.*? title=\"(.*?)\""
    case xibValue = "value=\"(.*?)\""
    case genericString = "\"(.*?)\""
    case encodedString = "\"[^\\W](.*?)\""
}
