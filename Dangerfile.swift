import Danger
import Foundation

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
    warn("Big PR, try to keep changes smaller if you can")
}

SwiftLint.lint(.modifiedAndCreatedFiles(directory: nil), inline: true)

// Support running via `danger local`
if danger.github != nil {
    // These checks only happen on a PR
    if danger.github.pullRequest.title.contains("WIP") {
        warn("PR is classed as Work in Progress")
    }
}
