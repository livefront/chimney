import Foundation
import SwiftCLI

let cli = CLI(name: "chimney")
cli.commands = [SetupCommand(), GenerateCommand(), GetCommand()]
cli.goAndExit()
