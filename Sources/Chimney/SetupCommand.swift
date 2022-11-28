import Foundation
import KeychainAccess
import PathKit
import SwiftCLI

class SetupCommand: Command {
    let name = "setup"
    let shortDescription = "Ensure keys are setup correctly in the keychain"

    let spec = Key<Path>(
        "-s",
        "--spec",
        description: "The path to the key spec file. Defaults to chimney.yml"
    )

    func execute() throws {
        let keySpec = try KeySpec(path: spec.value)
        let keyStore = KeyStore(spec: keySpec)

        do {
            try keyStore.generate()
        } catch KeySpecError.missingKeys(let keys) {
            for key in keys {
                stdout <<< "❌ Keys has detected a missing keychain value."
                stdout <<< "🔑 What is the key for \(key, color: .green)"
                var input = Input.readLine(prompt: ">", secure: true)

                if input.count == 128 {
                    stdout <<< "🚨 That key was too long for secure input. Please enter it again (will be visible)."
                    input = Input.readLine(prompt: ">", secure: false)
                }

                keyStore[key] = input
            }
        }

        stdout <<< "✅ All keys found. Ready to generate."
    }
}
