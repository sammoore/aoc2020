import Foundation

func set(string: String) -> Set<Character> {
  return Set(Array(string))
}

func encodedAnswers(_ input: String) -> [ArraySlice<String>] {
  return input.components(separatedBy: "\n").split(separator: "")
}

func day6_2(input: String) -> Int {
  return encodedAnswers(input)
    .map { arrOfAnswers in
      arrOfAnswers.reduce(set(string: arrOfAnswers.first!)) { (out, each) in
        out.intersection(set(string: each))
      }
    }
    .reduce(0) { (sum, each) in
      return sum + each.count
    }
}

func day6_1(input: String) -> Int {
  let records = encodedAnswers(input)
    .map { $0.joined() }
    .map { Array(Set($0)).count }
    
  let sum = records.reduce(0) { (acc, each) in acc + each }
  print("records: \(sum)")

  return 0
}
