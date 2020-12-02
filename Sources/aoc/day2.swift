import Foundation

struct PasswordRule {
  let character: Character
  let range: Range<Int>
  let rawRange: String?

  init(encoded: String) {
    // print("ruleEncoded: \(encoded)")
    let ruleEncodedParts: [String] = encoded.components(separatedBy: " ")
    let character = ruleEncodedParts[1]
    self.rawRange = ruleEncodedParts[0]
    let rangePair = ruleEncodedParts[0].components(separatedBy: "-").map { Int($0)! }
    let range: Range<Int> = rangePair[0] ..< (rangePair[1] + 1)

    self.character = Array(character)[0]
    self.range = range
  }

  func evaluate(_ password: String) -> Bool {
    return range ~= Array(password).filter { $0 == character }.count
  }

  func evaluate2(_ password: String) -> Bool {
    let nsRange = NSMakeRange(range.startIndex - 1, range.endIndex - range.startIndex)
    guard let stringRange = Range<String.Index>(nsRange, in: password) else { fatalError("range was invalid for string!") }

    let substr = Array(String(password[stringRange]))
    let first = substr[0]
    let second = substr[substr.count - 1]
    return [first, second].filter { $0 == character }.count == 1
  }
}

struct PasswordRow {
  public let password: String
  public let rule: PasswordRule

  init(password: String, rule: PasswordRule) {
    self.password = password
    self.rule = rule
  }

  init(encoded: String) {
    let parts: [String] = encoded.components(separatedBy: ": ").map { String($0) }
    let password: String = parts[1]

    self.password = password
    self.rule = PasswordRule(encoded: parts[0])
  }
}

func day2_1(input: String) -> Int? {
  let encodedPairs = input.split(separator: "\n").map { String($0) }
  
  return encodedPairs
    .map { encoded in PasswordRow(encoded: encoded) }
    .map { row in row.rule.evaluate(row.password) }
    .filter { $0 == true }
    .count
}

func day2_2(input: String) -> Int? {
  let encodedPairs = input.split(separator: "\n").map { String($0) }
  
  return encodedPairs
    .map { encoded in PasswordRow(encoded: encoded) }
    .map { row in row.rule.evaluate2(row.password) }
    .filter { $0 == true }
    .count
}
