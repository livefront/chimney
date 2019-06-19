import Foundation
import PathKit
import SwiftCLI

enum GenerateError: Error, ProcessError {
    case missingKeySpec(Path)
    case missingKey(String)

    var message: String? {
        switch self {
            case .missingKey(let key):
                return "No key found in keychain for \(key, color: .green). Run \("keys setup", color: .magenta) to enter missing values."
            case .missingKeySpec(let path):
                return "No key spec found at \(path.absolute())"
        }
    }

    var exitStatus: Int32 {
        return 1
    }
}
