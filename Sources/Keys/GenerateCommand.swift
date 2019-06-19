import Foundation
import KeychainAccess
import PathKit
import Stencil
import SwiftCLI

class GenerateCommand: Command {
    let name = "generate"
    
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
        let keySpecPath = (spec.value ?? "keys.yml").absolute()

        guard keySpecPath.exists else {
            throw GenerateError.missingKeySpec(keySpecPath)
        }

        let keySpec = try KeySpec(path: keySpecPath)

        let outputPath = (output.value ?? keySpec.outputPath).absolute()

        stdout <<< "🏭 Generating \(outputPath)..."

        let keychain = Keychain(service: "com.livefront.keys.\(keySpec.name)")

        var secrets: [[String: String]] = []

        for key in keySpec.keys {
            guard let value = keychain[key] else {
                throw GenerateError.missingKey(key)   
            }

            secrets.append([
                "key": key,
                "value": value,
            ])              
        }

        let context: [String: Any] = [
            "name": keySpec.name,
            "secrets": secrets
        ]

        let fsLoader = FileSystemLoader(paths: ["Templates/"])
        let environment = Environment(loader: fsLoader)
    
        let rendered = try environment.renderTemplate(name: "keys.stencil", context: context)
        try outputPath.write(rendered)
    }
}