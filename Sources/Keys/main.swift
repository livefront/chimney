import Foundation
import SwiftCLI

let keysCLI = CLI(name: "keys")
keysCLI.commands = [SetupCommand(), GenerateCommand()]
keysCLI.goAndExit()