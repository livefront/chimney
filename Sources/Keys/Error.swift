import Foundation
import PathKit
import SwiftCLI

enum KeySpecError: Error, ProcessError {
    case missingKeySpec(Path)
    case missingKey(String)

    var message: String? {
        switch self {
            case .missingKey(let key):
                return "\("Error:", color: .red) No key found in keychain for \(key, color: .green). Run \("keys setup", color: .magenta) to enter missing values."
            case .missingKeySpec(let path):
                return "\("Error:", color: .red) No spec found at \(path.absolute())"
        }
    }

    var exitStatus: Int32 {
        return 1
    }
}
