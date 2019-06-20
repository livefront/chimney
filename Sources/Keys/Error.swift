import Foundation
import PathKit
import SwiftCLI

enum KeySpecError: Error, ProcessError {
    case missingKeySpec(Path)
    case missingKeys([String])

    var message: String? {
        switch self {
            case .missingKeys(let keys):
                return "\("Error:", color: .red) No value found in keychain for \(keys, color: .green). Run \("keys setup", color: .magenta) to enter missing values."
            case .missingKeySpec(let path):
                return "\("Error:", color: .red) No spec found at \(path.absolute())"
        }
    }

    var exitStatus: Int32 {
        return 1
    }
}
