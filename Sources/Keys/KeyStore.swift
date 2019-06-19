import Foundation
import KeychainAccess

class KeyStore {
    let spec: KeySpec
    let keychain: Keychain
    let environment: [String: String]

    init(spec: KeySpec) {
        self.spec = spec

        keychain = Keychain(service: "com.livefront.keys.\(spec.name)")
        environment = ProcessInfo.processInfo.environment
    }

    subscript(_ key: String) -> String? {
        get {
            return environment[key] ?? keychain[key]
        }
        set {
            keychain[key] = newValue
        }
    }

    func validate() throws {
        for key in spec.keys {
            if self[key] == nil {
                throw KeySpecError.missingKey(key)
            }
        }
    }

    func generate() throws -> [[String: String]] {
        var keys: [[String: String]] = []

        for key in spec.keys {
            guard let value = self[key] else {
                throw KeySpecError.missingKey(key)   
            }

            keys.append([
                "name": key,
                "value": value,
            ])              
        }

        return keys
    }
} 

