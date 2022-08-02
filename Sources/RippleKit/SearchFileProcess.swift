//
//  SearchFileProcess.swift
//  
//
//  Created by Edoardo Benissimo on 25/07/22.
//

import Foundation
import PathKit

public struct SearchFileProcess {
    let findProcess: Process
    init?(path: Path, excluded: [Path]) {
        findProcess = Process()
        findProcess.launchPath = "/usr/bin/find"
        var arguments = [String]()
        
        arguments.append(path.string)
        arguments.append("-name")
        arguments.append("*.strings")

        for path in excluded {
            arguments.append("-not")
            arguments.append("-path")
            path.isDirectory ? arguments.append("\(path.string)/*") : arguments.append(path.string)
        }
        findProcess.arguments = arguments
    }
    
    func execute() -> Set<String> {
        let pipe = Pipe()
        findProcess.standardOutput = pipe
        
        let fileHandler = pipe.fileHandleForReading
        findProcess.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}
