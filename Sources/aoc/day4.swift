import Foundation

enum Unit: String {
  case `in` = "in"
  case cm = "cm"
}

enum EyeColor: String {
  case amb = "amb"
  case blu = "blu"
  case brn = "brn"
  case gry = "gry"
  case grn = "grn"
  case hzl = "hzl"
  case oth = "oth"
}

let hclRegex = try! NSRegularExpression(pattern: "^[#][0-9a-f]{6}")

struct Passport {
  // var because technically a record could have more than one for same key / be somewhat invalid
  // it could be refactored to avoid this but time
  // this could also be totally written differently to avoid the switch in init(encoded:) buuuuuut
  var byr: String? // (Birth Year)
  var iyr: String? // (Issue Year)
  var eyr: String? //  (Expiration Year)
  var hgt: String? // (Height)
  var hcl: String? // (Hair Color)
  var ecl: String? // (Eye Color)
  var pid: String? // (Passport ID)
  var cid: String? // (Country ID) 

  var valid: Bool {
    return true
      && byr != nil
      && iyr != nil
      && eyr != nil
      && hgt != nil
      && hcl != nil
      && ecl != nil
      && pid != nil
  }

  init(encoded: String) {
    let encodedPropPairs: [[String]] = encoded
      .components(separatedBy: " ")
      .map { $0.components(separatedBy: ":") }
    
    for pair in encodedPropPairs {
    checkProp: switch pair[0] {
      case "byr":
        guard let num = Int(pair[1]), num >= 1920, num <= 2002 else { break }
        self.byr = pair[1]
      case "iyr":
        guard let num = Int(pair[1]), 2010 ... 2020 ~= num else { break }
        self.iyr = pair[1]
      case "eyr":
        guard let num = Int(pair[1]), 2020 ... 2030 ~= num else { break }
        self.eyr = pair[1]
      case "hgt":
        let encodedUnit = pair[1].replacingOccurrences(
          of: "[0-9]",
          with: "",
          options: [.regularExpression]
        )

        print("unit: \(encodedUnit)")

        let encodedNum = pair[1].replacingOccurrences(
          of: "[a-zA-Z]",
          with: "",
          options: [.regularExpression]
        )

        print("num: \(encodedNum)")

        guard let num = Int(encodedNum), let unit = Unit(rawValue: encodedUnit) else {
          break
        }

        print("THEY BOTH ARE SET")

        switch unit {
        case .cm: if !(150 ... 193 ~= num) { break checkProp }
        case .in: if !(59 ... 76 ~= num) { break checkProp }
        }

        print ("VALID BITCHES")

        self.hgt = pair[1]
      case "hcl":
        let range = NSRange(location: 0, length: pair[1].utf8.count)
        guard hclRegex.matches(in: pair[1], range: range).count > 0 else {
          break
        }
        self.hcl = pair[1]
      case "ecl":
	guard let _ = EyeColor(rawValue: pair[1]) else { break }
        self.ecl = pair[1]
      case "pid":
	guard pair[1].utf8.count == 9 else { break }
        self.pid = pair[1]
      case "cid":
        self.cid = pair[1]
      default: break
      }
    }
  }
}

func parsePassports(_ encoded: String) -> [Passport] {
  let encodedPassports: [String] = encoded
    .split(separator: "\n")
    .split(separator: "")
    .map { $0.joined(separator: " ") }

  return encodedPassports
    .map { Passport(encoded: $0) }
}

func day4(input: String) -> Int {
  let list = parsePassports(input)

  // for item in list { print(item) }

  return list.filter { $0.valid }.count
}
