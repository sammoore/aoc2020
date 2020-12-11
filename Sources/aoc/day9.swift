import Foundation

let GROUP_SIZE = 25
struct Pair<L, R> { let left: L; let right: R }

func findContiguousAddends(in numbers: [Int], forSum sum: Int) -> [Int] {
  for (firstIndex, _) in numbers.enumerated() {
    for (index, _) in numbers[firstIndex ..< numbers.count].enumerated() {
      let set = numbers[firstIndex ... (index + firstIndex)]
      if (set.reduce(0) { $0 + $1 }) == sum { return Array(set) }
    }
  }

  fatalError("no set found")
}

func day9(input: String) -> Pair<Int, [Int]> {
  let nums = input
    .components(separatedBy: "\n")
    .dropLast()
    .map { Int($0)! }

  outer: for (index, num) in nums.enumerated() {
    guard index >= nums.startIndex + GROUP_SIZE else { continue }
    let lastGroup = nums[index-GROUP_SIZE ..< index]
    
    for x in lastGroup {
      for y in lastGroup {
        guard x != y else { continue }
        if (x + y) == num { continue outer }
      }
    }

    let contiguousAddends = findContiguousAddends(in: nums, forSum: num)
    let minAndMax = [contiguousAddends.min()!, contiguousAddends.max()!]

    return Pair(
      left: num,
      right: minAndMax
    )
  }

  return Pair(left: -1, right: [])
}
