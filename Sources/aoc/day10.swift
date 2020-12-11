import Foundation

func parseAdapters(_ input: String) -> [Int] {
  return input
    .components(separatedBy: "\n")
    .dropLast()
    .map { Int($0)! }
    .sorted(by: <)
}

func day10(input: String) -> Int {
  let adapters: [Int] = parseAdapters(input)
  var numWaysToGetThereByJoltage: Dictionary<Int, Int> = [0:1]

  for adapter in adapters {
    // the 3 numbers before `adapter`, regardless of whether they were in the input
    let possiblyInvalidPreviousSteppingStones = (adapter-3) ..< adapter

    // since we're counting up in order, we can see if the key exists in what we've found so far
    let validPreviousSteppingStones = possiblyInvalidPreviousSteppingStones.filter {
      numWaysToGetThereByJoltage.keys.contains($0)
    }

    // sum up the ways to get to the previous stepping stones
    numWaysToGetThereByJoltage[adapter] = validPreviousSteppingStones.reduce(0) { (sum, stone) in
      return sum + numWaysToGetThereByJoltage[stone]!
    }
  }

  return numWaysToGetThereByJoltage[numWaysToGetThereByJoltage.keys.max()!]!
}

func day10_1(input: String) -> Int {
  let adapters = parseAdapters(input)
  var diffs: [Int] = []
  var currentJolts: Int = 0 // starting with airplane output

  for output in adapters {
    diffs.append(output - currentJolts)
    currentJolts = output
  }

  // for built-in adapter
  diffs.append(3)
  currentJolts += 3

  return diffs.filter { $0 == 1 }.count * diffs.filter { $0 == 3}.count
}
