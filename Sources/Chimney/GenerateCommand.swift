import Foundation
import KeychainAccess
import PathKit
import Stencil
import SwiftCLI

class GenerateCommand: Command {
    let name = "generate"
    let shortDescription = "Generates a swift class containing your keys"
    
    let spec = Key<Path>(
        "-s",
        "--spec",
        description: "The path to the key spec file. Defaults to chimney.yml"
    )

    let output = Key<Path>(
        "-o",
        "--output",
        description: "The output file. Defaults to [keyspec name]Keys.swift"
    )

    @Flag(
        "-d",
        "--dummy",
        description: "Indicates if dummy keys with the value 'xxxx' should be generated instead of referencing KeyChain for the keys. Defaults to false."
    )
    var dummy: Bool

    func execute() throws {
        let keySpec = try KeySpec(path: spec.value)
        let outputPath = (output.value ?? keySpec.outputPath).absolute()

        stdout <<< "🏭 Generating \(outputPath)..."

        let keys: [KeyEntry]
        if dummy {
            let dummyKeyStore = DummyKeyStore(spec: keySpec)
            keys = dummyKeyStore.generate()
        } else {
            let keyStore = KeyStore(spec: keySpec)
            keys = try keyStore.generate()
        }
        let context: [String: Any] = [
            "name": keySpec.name,
            "keys": keys
        ]

        let bundlePath = Path(Bundle.main.bundlePath)
        let relativePath = Path("Templates")
        let fsLoader = FileSystemLoader(paths: [
            relativePath,
            bundlePath,
            bundlePath + relativePath
        ])
        let environment = Environment(loader: fsLoader)
        let rendered = try environment.renderTemplate(name: "chimney.stencil", context: context)
        try outputPath.write(rendered)
    }
}
