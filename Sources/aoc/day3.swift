import Foundation

enum MapTile: Character {
  case none = "."
  case tree = "#"
}

struct Coordinate {
  let x: Int
  let y: Int
}

struct Map {
  let lines: [String.SubSequence]

  init(encoded: String) {
    self.lines = encoded.split { $0.isNewline }
  }

  func enumerate(_ startCoordinate: Coordinate, xMove: Int = 3, yMove: Int = 1) -> Coordinate? {
    let coordinate = Coordinate(
      x: (startCoordinate.x + xMove) % lines[startCoordinate.y].count,
      y: startCoordinate.y + yMove
    )

    guard coordinate.y < lines.count else {
      return nil
    }

    return coordinate
  }

  func tile(at coordinate: Coordinate) -> MapTile? {
    // TODO: there MUST be a better way to do this in type-safe swift :eyeroll:
    guard coordinate.y < lines.count else { return nil }
    let line = lines[coordinate.y]

    return MapTile(rawValue: line[line.index(line.startIndex, offsetBy: coordinate.x)])
  }
}

func evaluate(map: Map, start _start: Coordinate, xMove: Int, yMove: Int) -> Int {
  var start: Coordinate? = _start
  var count = 0

  while let coordinate = start {
    if map.tile(at: coordinate) == .tree {
      count += 1
    }

    start = map.enumerate(coordinate, xMove: xMove, yMove: yMove)
  }

  return count
}

func day3_1(input: String) -> Int {
  let map = Map(encoded: input)
  let start = Coordinate(x: 0, y: 0)

  return evaluate(map: map, start: start, xMove: 3, yMove: 1)
}

func day3_2(input: String) -> Int {
  let map = Map(encoded: input)
  let start = Coordinate(x: 0, y: 0)

  let results: [Int] = [
    evaluate(map: map, start: start, xMove: 1, yMove: 1),
    evaluate(map: map, start: start, xMove: 3, yMove: 1),
    evaluate(map: map, start: start, xMove: 5, yMove: 1),
    evaluate(map: map, start: start, xMove: 7, yMove: 1),
    evaluate(map: map, start: start, xMove: 1, yMove: 2)
  ]
  
  return results.reduce(1) { (acc, each) in acc * each }
}
