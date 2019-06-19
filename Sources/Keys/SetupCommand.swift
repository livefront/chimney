import Foundation
import KeychainAccess
import PathKit
import SwiftCLI

class SetupCommand: Command {
    let name = "setup"
    
    let spec = Key<Path>(
        "-s",
        "--spec",
        description: "The path to the key spec file. Defaults to keys.yml"
    )

    func execute() throws {
        let keySpecPath = (spec.value ?? "keys.yml").absolute()
        let keySpec = try KeySpec(path: keySpecPath)

        let keychain = Keychain(service: "com.livefront.keys.\(keySpec.name)")
        for key in keySpec.keys {
            if keychain[key] == nil {
                stdout <<< "❌ Keys has detected a missing keychain value."
                stdout <<< "🔑 What is the key for \(key, color: .green)"
                keychain[key] = Input.readLine(prompt: ">", secure: true)
            }
        }

        stdout <<< "✅ All keys found. Ready to generate."
    }
}
