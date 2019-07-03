import Foundation

extension String {
    func snakeCased() -> String {
        guard let regexSplitAcronyms = try? NSRegularExpression(pattern: "(.)([A-Z][a-z]+)", options: []),
              let regexSplitWords = try? NSRegularExpression(pattern: "([a-z0-9])([A-Z])", options: []) else {
                  return self
              }

        // Step 1: Split "APISecretKey" into "API_SecretKey"
        let range = NSRange(location: 0, length: count)
        let snakedAcronyms = regexSplitAcronyms.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")

        // Step 2: Split "API_SecretKey" into "API_Secret_Key"
        let snakedAcronymsRange = NSRange(location: 0, length: snakedAcronyms.count)
        let snakedWords = regexSplitWords.stringByReplacingMatches(in: snakedAcronyms, options: [], range: snakedAcronymsRange, withTemplate: "$1_$2")

        return snakedWords.uppercased()
    }
} 

