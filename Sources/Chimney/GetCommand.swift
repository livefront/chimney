import PathKit
import SwiftCLI

class GetCommand: Command {
    let name = "get"
    let shortDescription = "Outputs a secret from the keychain for the key"

    let spec = Key<Path>(
        "-s",
        "--spec",
        description: "The path to the key spec file. Defaults to chimney.yml"
    )

    @Param var key: String

    func execute() throws {
        let keySpec = try KeySpec(path: spec.value)
        let keyStore = KeyStore(spec: keySpec)

        guard let value = keyStore[key] else {
            throw KeySpecError.missingKey(key)
        }

        stdout <<< value
    }
}
