import Foundation

let filePath: String = Bundle.module.path(forResource: "input", ofType: "txt")!
let contents = String(decoding: try! Data(contentsOf: URL(fileURLWithPath: filePath)), as: UTF8.self)

func day1_1(input: String) -> Int? {
  let values = input.split(separator: "\n").map { String($0) }.map { Int($0)! }
  var ret: Int? = nil

  for outer in values {
    for inner in values {
      if (outer + inner) == 2020 {
        ret = outer * inner
        break
      }
    }

    if ret != nil {
      break
    }
  }

  return ret
}

func day1_2(input: String) -> Int? {
  let values = input.split(separator: "\n").map { String($0) }.map { Int($0)! }
  var ret: Int? = nil

  for outer in values {
    for middle in values {
      for inner in values {
        if (outer + middle + inner) == 2020 {
          ret = outer * middle * inner
          break
        }
      }
    }

    if ret != nil {
      break
    }
  }

  return ret
}

var answer: Int? = day1_2(input: contents)

guard let answer = answer else {
  fatalError("no match found")
}

print(answer)
