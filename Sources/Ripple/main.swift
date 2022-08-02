import Foundation
import CommandLineKit
import RippleKit

let cli = CommandLineKit.CommandLine()

let projectPathOptions = StringOption(shortFlag: "p",
                                      longFlag: "project",
                                      helpMessage: "Root path of your Xcode project")
cli.addOption(projectPathOptions)


let excludePathOption = MultiStringOption(shortFlag: "e",
                                          longFlag: "exclude",
                                          helpMessage: "Exclude paths from search.")
cli.addOption(excludePathOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if !cli.unparsedArguments.isEmpty {
    print("Unknow arguments: \(cli.unparsedArguments)")
    cli.printUsage()
    exit(EX_USAGE)
}

let projectPath = projectPathOptions.value ?? "."
let exludedPaths = excludePathOption.value ?? []
let ripple = Ripple(projectPath: projectPath, excludedPaths: exludedPaths)
ripple.echoMessage(arguments: "🏄 Analyze...")
let keys = ripple.getLocalizableKeys()

ripple.echoMessage(arguments: "✏️  \(keys.count) Localizable keys")

let allStrings = ripple.allUsedStringNames()

let differences = keys.subtracting(allStrings)
ripple.echoMessage(arguments: "🌊 Found \(differences.count) localizable string not used")

for difference in differences {
    ripple.addWarning(localizedKey: difference)
}

