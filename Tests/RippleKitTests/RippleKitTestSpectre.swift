//
//  File.swift
//  
//
//  Created by Edoardo Benissimo on 28/07/22.
//

import Foundation
import Spectre
@testable import RippleKit
import PathKit

public let testRippleKit: ((ContextType) -> Void) = {
    $0.describe("Regex rules") {
        $0.it("Search string in swift file") {
            let regex = [SearchRegex.genericString.rawValue]
            let content = "let a=\"prova\" let x = 4"
            let ripple = Ripple(projectPath: "", excludedPaths: [])
            let result = ripple.search(in: content, with: regex)
            let expected: Set<String> = ["prova"]
            try expect(result) == expected
        }
        $0.it("Search string in plist file") {
            let regex = [SearchRegex.plistString.rawValue, SearchRegex.plistKey.rawValue]
            let content = "<string>PLIST</string> <key>test</key> <dict></dict> <string>Hello</string>"
            let ripple = Ripple(projectPath: "", excludedPaths: [])
            let result = ripple.search(in: content, with: regex)
            let expected: Set<String> = ["PLIST", "test", "Hello"]
            try expect(result) == expected
        }
        $0.it("Search string in Xib & Storyboard") {
            let regex = [SearchRegex.xibText.rawValue, SearchRegex.xibValue.rawValue, SearchRegex.xibButton.rawValue]
            let content = """
                            <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" fixedFrame="YES" text="Test storyboard" textAlignment="natural" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="55D-4c-OSv">
                                <rect key="frame" x="147" y="244" width="120" height="21"/>
                                <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                                <fontDescription key="fontDescription" type="system" pointSize="17"/>
                                <nil key="textColor"/>
                                <nil key="highlightedColor"/>
                            </label>
                            <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" fixedFrame="YES" text="test 2 storyboard" textAlignment="natural" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="xA7-Ej-tut">
                                <rect key="frame" x="147" y="386" width="131" height="21"/>
                                <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                                <fontDescription key="fontDescription" type="system" pointSize="17"/>
                                <nil key="textColor"/>
                                <nil key="highlightedColor"/>
                            </label>
                            <button opaque="NO" contentMode="scaleToFill" fixedFrame="YES" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="system" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="Xtk-jv-52A">
                                <rect key="frame" x="160" y="513" width="95" height="31"/>
                                <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                                <state key="normal" title="Button"/>
                                <buttonConfiguration key="configuration" style="plain" title="test button"/>
                            </button>
"""
            let ripple = Ripple(projectPath: "", excludedPaths: [])
            let result = ripple.search(in: content, with: regex)
            let expected: Set<String> = ["Test storyboard", "test 2 storyboard", "test button"]
            try expect(result) == expected
        }
        
        $0.it("String contains string") {
            let content = "I'am a string, string test, test string, hello!"
            let ripple = Ripple(projectPath: "", excludedPaths: [])
            try expect(true) == content.contains(word: "string")
        }
    }
}
