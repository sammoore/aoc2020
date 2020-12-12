import Foundation

fileprivate enum MapTile: Character {
  case None = "."
  case EmptySeat = "L"
  case TakenSeat = "#"

  var isSeat: Bool {
    guard self != .None else { return false }
    return true
  }

  var isTakenSeat: Bool {
    guard isSeat && self == .TakenSeat else { return false }
    return true
  }
}

fileprivate func encoded(_ map: [[MapTile]]) -> String {
  let a = String(map.joined().map { $0.rawValue })
  return a
}

// this is ridiculous with .index instead of ints but it's too late
fileprivate func occupiedAdjacentSeats(in map: [[MapTile]], from origin: (x: Int, y: Int)) -> Int {
  // Top Left
  if origin.x == map[map.indices.first!].indices.first! && origin.y == map.indices.first! {
    let topRow = map[map.indices.first!]
    let secondRow = map[map.index(map.indices.first!, offsetBy: 1)]

    let right = topRow[topRow.index(topRow.indices.first!, offsetBy: 1)]
    let down = secondRow[secondRow.indices.first!]
    let diag = secondRow[secondRow.index(secondRow.indices.first!, offsetBy: 1)]

    return [right, down, diag].map { $0.isTakenSeat }.reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  // Top Right
  if origin.x == map[map.indices.first!].indices.last! && origin.y == map.indices.first! {
    let topRow = map[map.indices.first!]
    let secondRow = map[map.index(map.indices.first!, offsetBy: 1)]

    let left = topRow[topRow.index(topRow.indices.last!, offsetBy: -1)]
    let down = secondRow[secondRow.indices.last!]
    let diag = secondRow[secondRow.index(secondRow.indices.last!, offsetBy: -1)]

    return [left, down, diag].map { $0.isTakenSeat }.reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  // Bottom Right
  if origin.x == map[map.indices.last!].indices.last && origin.y == map.indices.last! {
    let bottomRow = map[map.indices.last!]
    let aboveRow = map[map.index(map.indices.last!, offsetBy: -1)]

    let left = bottomRow[bottomRow.index(bottomRow.indices.last!, offsetBy: -1)]
    let up = aboveRow[aboveRow.indices.last!]
    let diag = aboveRow[aboveRow.index(aboveRow.indices.last!, offsetBy: -1)]

    return [left, up, diag].map { $0.isTakenSeat }.reduce(0) { $0 + ($1 ? 1 : 0) }

  }

  // Bottom Left
  if origin.x == map[map.indices.last!].indices.first && origin.y == map.indices.last! {
    let bottomRow = map[map.indices.last!]
    let aboveRow = map[map.index(map.indices.last!, offsetBy: -1)]

    let right = bottomRow[bottomRow.index(bottomRow.indices.first!, offsetBy: 1)]
    let up = aboveRow[aboveRow.indices.first!]
    let diag = aboveRow[aboveRow.index(aboveRow.indices.first!, offsetBy: 1)]

    return [right, up, diag].map { $0.isTakenSeat }.reduce(0) { $0 + ($1 ? 1 : 0) }

  }

  // Top
  if origin.y == 0 {
    return ([
      map[origin.y][origin.x - 1],
      map[origin.y][origin.x + 1],
      map[origin.y + 1][origin.x - 1],
      map[origin.y + 1][origin.x],
      map[origin.y + 1][origin.x + 1]
    ].map { $0.isTakenSeat }).reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  // Right
  if origin.x == map[0].indices.last! {
    return ([
      map[origin.y - 1][origin.x - 1],
      map[origin.y - 1][origin.x],
      map[origin.y][origin.x - 1],
      map[origin.y + 1][origin.x - 1],
      map[origin.y + 1][origin.x]
    ].map { $0.isTakenSeat }).reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  // Bottom
  if origin.y == map.indices.last! {
    return ([
      map[origin.y - 1][origin.x - 1],
      map[origin.y - 1][origin.x],
      map[origin.y - 1][origin.x + 1],
      map[origin.y][origin.x - 1],
      map[origin.y][origin.x + 1]
    ].map { $0.isTakenSeat }).reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  // Left
  if origin.x == 0 {
    return ([
      map[origin.y - 1][origin.x],
      map[origin.y - 1][origin.x + 1],
      map[origin.y][origin.x + 1],
      map[origin.y + 1][origin.x],
      map[origin.y + 1][origin.x + 1]
    ].map { $0.isTakenSeat }).reduce(0) { $0 + ($1 ? 1 : 0) }
  }

  let indices = [
    map[origin.y - 1][origin.x - 1],
    map[origin.y - 1][origin.x],
    map[origin.y - 1][origin.x + 1],
    map[origin.y][origin.x - 1],
    map[origin.y][origin.x + 1],
    map[origin.y + 1][origin.x - 1],
    map[origin.y + 1][origin.x],
    map[origin.y + 1][origin.x + 1]
  ]

  return indices
    .map { $0.isTakenSeat }
    .reduce(0) { $0 + ($1 ? 1 : 0) }
}

fileprivate func applyHumanBehavior(map: [[MapTile]]) -> [[MapTile]] {
  var newMap = map // pretty sure Swift will copy in this instance

  for (y, line) in map.enumerated() {
    for (x, _) in line.enumerated() {
      let seat = map[y][x]
      let count = occupiedAdjacentSeats(in: map, from: (x: x, y: y))

      if seat == MapTile.EmptySeat && count == 0 {
        newMap[y].replaceSubrange(x..<x+1, with: [MapTile.TakenSeat])
        continue
      }

      if seat == MapTile.TakenSeat && count >= 4 {
        newMap[y].replaceSubrange(x..<x+1, with: [MapTile.EmptySeat])
        continue
      }
    }
  }

  return newMap
}

func day11(input: String) -> Int {
  var map: [[MapTile]] = input
    .components(separatedBy: "\n")
    .dropLast()
    .map { line in Array(line).map { MapTile(rawValue: $0)! } }
  var newMap = applyHumanBehavior(map: map)

  while encoded(map) != encoded(newMap) {
    map = newMap
    newMap = applyHumanBehavior(map: map)
  }

  return newMap.joined().filter { $0 == MapTile.TakenSeat }.count
}
