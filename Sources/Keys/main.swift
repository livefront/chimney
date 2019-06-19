import Foundation
import SwiftCLI

let cli = CLI(name: "keys")
cli.commands = [SetupCommand(), GenerateCommand()]
cli.goAndExit()