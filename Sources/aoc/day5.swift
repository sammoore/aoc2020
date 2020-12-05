import Foundation

enum FrontBack: Character {
  case Front = "F"
  case Back = "B"
}

enum LeftRight: Character {
  case Left = "L"
  case Right = "R"
}

struct SeatPlan {
  private var data: [[Int]]

  var ids: [Int] { data.flatMap { $0 }.filter { $0 >= 0 } }

  var mine: Int? {
    let sorted = ids.sorted()
    for (index, value) in sorted.enumerated() {
      if 0 ..< sorted.count ~= index + 1 && sorted[index + 1] - 2 == value {
        return value + 1
      }
    }
    return nil
  }

  init() {
    self.data = Array(repeating: Array(repeating: -1, count: 8), count: 128)
  }

  private init(data: [[Int]]) {
    self.data = data
  }

  func populateSeat(_ encoded: String) -> SeatPlan {
    var i = 128
    var j = 8
    var y = 0
    var x = 0

    for char in encoded {
      if let char = FrontBack(rawValue: char) {
        i /= 2
        if char == .Back { y += i }
      }
      else if let char = LeftRight(rawValue: char) {
        j /= 2
        if char == .Right { x += j }
      }
      else {
        break
      }
    }

    var newData = data
    newData[y][x] = (y * 8) + x
    return SeatPlan(data: newData)
  }
}

func day5(input: String) -> (Int, Int?) {
  let plan = input
    .components(separatedBy: "\n")
    .reduce(SeatPlan()) { (plan, seat) in
      plan.populateSeat(seat)
    }

  return (plan.ids.max()!, plan.mine)
}
