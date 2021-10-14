import Foundation
import PathKit
import SwiftCLI

extension Path: ConvertibleFromString {
    public init?(input: String) {
        self = Path(input)
    }
}
