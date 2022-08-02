//
//  Ripple.swift
//  
//
//  Created by Edoardo Benissimo on 22/07/22.
//

import Foundation
import PathKit

public struct Ripple {
    let projectPath: Path
    let excludedPaths: [Path]
    let extensions: [String] = ["swift", "xib", "storyboard", "plist", "xcconfig"]
    public init(projectPath: String, excludedPaths: [String]) {
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludedPaths = excludedPaths.map { path + Path($0) }
    }
    
    public func getLocalizableKeys() -> Set<String> {
        let file = SearchFileProcess(path: projectPath, excluded: excludedPaths)
        guard let result = file?.execute() else {
            print("❌ Fail to find resources")
            return []
        }
        var localizedKey = Set<String>()
        for file in result {
            let path = Path(file)
            let content = (try? path.read()) ?? ""
            localizedKey = localizedKey.union(search(in: content, with: [SearchRegex.localizedKey.rawValue]))
        }
        return localizedKey
    }
    
    private func getLocalizableFile() -> [Path] {
        let file = SearchFileProcess(path: projectPath, excluded: excludedPaths)
        guard let result = file?.execute() else {
            print("❌ Fail to find resources")
            return []
        }
        return result.map { Path($0) }
    }
    public func addWarning(localizedKey: String) {
        let localizableFile = getLocalizableFile()
        for file in localizableFile {
            let content = (try? file.read()) ?? ""
            var lineNumber = 1
            content.enumerateLines { line, stop in
                if line.contains(word: localizedKey) {
                    self.echoMessage(arguments: "\(file.string):\(lineNumber): warning: \(localizedKey) is unused")
                }
                lineNumber += 1
            }
        }
    }
    public func allUsedStringNames() -> Set<String> {
        return usedStringNames(at: projectPath)
    }
    private func usedStringNames(at path: Path) -> Set<String> {
        guard let subPaths = try? path.children() else {
            print("Failed to get contents in path: \(path)")
            return []
        }
        var result = [String]()
        for subPath in subPaths {
            if excludedPaths.contains(subPath) {
                continue
            }
            if subPath.isDirectory {
                result.append(contentsOf: usedStringNames(at: subPath))
            } else {
                let fileExt = subPath.extension ?? ""
                guard extensions.contains(fileExt) else {
                    continue
                }
                let searchRules = [SearchRegex.genericString.rawValue, SearchRegex.xibText.rawValue, SearchRegex.xibValue.rawValue, SearchRegex.plistString.rawValue, SearchRegex.plistKey.rawValue, SearchRegex.xibButton.rawValue]
                
                let content = (try? subPath.read()) ?? ""
                result.append(contentsOf: search(in: content, with: searchRules).map { name in
                    let p = Path(name)
                    guard let ext = p.extension else { return name }
                    return extensions.contains(ext) ? p.lastComponentWithoutExtension : name
                })
            }
        }
        return Set(result)
    }
    public func search(in content: String, with patterns: [String]) -> Set<String> {
        var result = Set<String>()
        for pattern in patterns {
            let searchRegex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = searchRegex.matches(in: content, options: [], range: content.fullRange)
            for checkingResult in matches {
                let extracted = NSString(string: content).substring(with: checkingResult.range(at: 1))
                result.insert(extracted)
            }
        }
        print(result)
        return result
    }
    public func echoMessage(arguments: String) {
        let echoProcess = Process()
        echoProcess.launchPath = "/usr/bin/env"
        let arguments = ["echo", arguments]
        echoProcess.arguments = arguments
        echoProcess.launch()
        echoProcess.waitUntilExit()
    }
}
