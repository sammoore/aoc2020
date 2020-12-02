import Foundation

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


