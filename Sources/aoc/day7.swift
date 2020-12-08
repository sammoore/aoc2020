import Foundation

extension Int {
  func of<T>(_ value: T) -> [T] {
    return Array(repeating: value, count: self)
  }
}

func rule(_ encoded: String) -> (String, [String]) {
  let parts = encoded.components(separatedBy: " bags contain ")
  
  return (parts.first!, parts.last!
    .replacingOccurrences(of: "( bags?|[.])", with: "", options: [.regularExpression])
    .components(separatedBy: ", ")
    .reduce([]) { (requirements, each) in
      let encodedCount = String(each.split(separator: " ").first!)
      if encodedCount == "no" {
        return requirements
      } else {
        let count = Int(encodedCount)!
        let type = String(each.split(separator: " ").dropFirst().joined(separator: " "))
        return requirements + count.of(type)
      }
    }
  )
}

func contents(of: String, given rules: Dictionary<String, [String]>) -> [String] {
  return rules[of]!.reduce(rules[of]!) { (out, each) in
    out + contents(of: each, given: rules)
  }
}

func day7_1(input: String) -> Int {
  let rules: Dictionary<String, [String]> = input
    .components(separatedBy: "\n")
    .reduce([:]) { (out, each) in
      guard each != "" else { return out }
      let (type, requirements) = rule(each)
      return out.merging([type: requirements]) { $1 }
    }

  let contentsByOutermostBag: Dictionary<String, [String]> = rules.keys
    .reduce([:]) { (out, type) in
      return out.merging([type: contents(of: type, given: rules)]) { $1 }
    }

  return contentsByOutermostBag
    .filter { (key, bags) in bags.contains("shiny gold") }
    .keys
    .count
}
