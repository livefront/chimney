import Foundation
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
}
