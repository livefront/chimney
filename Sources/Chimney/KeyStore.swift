import Foundation
import KeychainAccess

struct KeyEntry {
    let name: String
    let value: String
}

class KeyStore {
    let spec: KeySpec
    let keychain: Keychain
    let environment: [String: String]

    init(spec: KeySpec) {
        self.spec = spec

        keychain = Keychain(service: "com.livefront.chimney.\(spec.name)")
        environment = ProcessInfo.processInfo.environment
    }

    subscript(_ key: String) -> String? {
        get {
            return environment[key] ?? environment[key.uppercased()] ?? keychain[key]
        }
        set {
            keychain[key] = newValue
        }
    }

    @discardableResult
    func generate() throws -> [KeyEntry] {
        var keys: [KeyEntry] = []
        var missing: [String] = []

        for key in spec.keys {
            if let value = self[key] {
                keys.append(KeyEntry(name: key, value: value))
            } else {
                missing.append(key)
            }
        }

        guard missing.isEmpty else {
            throw KeySpecError.missingKeys(missing)
        }

        return keys
    }
} 

