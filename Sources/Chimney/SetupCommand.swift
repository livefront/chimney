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
        description: "The path to the key spec file. Defaults to keys.yml"
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
                keyStore[key] = Input.readLine(prompt: ">", secure: true)
            }
        }

        stdout <<< "✅ All keys found. Ready to generate."
    }
}
