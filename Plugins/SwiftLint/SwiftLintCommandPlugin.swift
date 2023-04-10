import Foundation
import PackagePlugin

@main
struct SwiftLintCommandPlugin: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) throws {
        let swiftlintTool = try context.tool(named: "swiftlint")
        let swiftlintExecutableURL = URL(fileURLWithPath: swiftlintTool.path.string)
        var swiftlintArguments = [
            "lint",
            "--cache-path",
            context.pluginWorkDirectory.string
        ]

        var argumentExtractor = ArgumentExtractor(arguments)

        if let configFile = argumentExtractor.extractOption(named: "config").first {
            swiftlintArguments.append(contentsOf: ["--config", configFile])
        }

        if let reporter = argumentExtractor.extractOption(named: "reporter").first {
            swiftlintArguments.append(contentsOf: ["--reporter", reporter])
        }

        if argumentExtractor.extractFlag(named: "strict") > 0 {
            swiftlintArguments.append("--strict")
        }

        let process = try Process.run(swiftlintExecutableURL, arguments: swiftlintArguments)
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            Diagnostics.error("'swiftlint' failed")
        }
    }

}
