import Foundation
import KeychainAccess
import PathKit
import Yams

struct KeySpec: Codable {
    var name: String
    let keys: [String]

    var outputPath: Path {
        return Path("\(name)Keys.swift")
    }

    init(path: Path?) throws {
        let keySpecPath = (path ?? "keys.yml").absolute()
        guard keySpecPath.exists else {
            throw KeySpecError.missingKeySpec(keySpecPath)
        }

        let yml: String = try keySpecPath.read()

        let decoder = YAMLDecoder()
        self = try decoder.decode(KeySpec.self, from: yml)
    }

    func validate() throws {
        let keychain = Keychain(service: "com.livefront.keys.\(name)")

        for key in keys {
            let value = ProcessInfo.processInfo.environment[key] ?? keychain[key]
            guard value != nil else {
                throw KeySpecError.missingKey(key)   
            }
        }
    }
}
