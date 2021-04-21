import Danger
import Foundation

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
    warn("Big PR, try to keep changes smaller if you can")
}

SwiftLint.lint()
