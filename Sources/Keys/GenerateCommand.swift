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
        description: "The path to the key spec file. Defaults to keys.yml"
    )

    let output = Key<Path>(
        "-o",
        "--output",
        description: "The output file. Defaults to [keyspec name]Keys.swift"
    )

    func execute() throws {
        let keySpec = try KeySpec(path: spec.value)

        let outputPath = (output.value ?? keySpec.outputPath).absolute()

        stdout <<< "🏭 Generating \(outputPath)..."

        let keyStore = KeyStore(spec: keySpec)
        let keys = try keyStore.generate()
        let context: [String: Any] = [
            "name": keySpec.name,
            "keys": keys
        ]

        let fsLoader = FileSystemLoader(paths: ["Templates/"])
        let environment = Environment(loader: fsLoader)
    
        let rendered = try environment.renderTemplate(name: "keys.stencil", context: context)
        try outputPath.write(rendered)
    }
}