import Foundation

/// A dummy version of the `KeyStore` used to generate dummy keys instead of keys pulled from `KeychainAccess`.
class DummyKeyStore {
    let spec: KeySpec

    init(spec: KeySpec) {
        self.spec = spec
    }

    func generate() -> [KeyEntry] {
        return spec.keys.map {
            KeyEntry(name: $0, value: "xxxx")
        }
    }
}
