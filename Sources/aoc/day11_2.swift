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

fileprivate func seenSeats(in map: [[MapTile]], from origin: (x: Int, y: Int)) -> [MapTile] {
  var offset = 1

  var upLeft: MapTile? = nil
  repeat {
    let y = origin.y - offset
    let x = origin.x - offset

    guard map.indices.contains(y), map[0].indices.contains(x) else { break }

    upLeft = map[y][x]
    offset += 1
  } while upLeft == .None

  offset = 1

  var up: MapTile? = nil
  repeat {
    let y = origin.y - offset

    guard map.indices.contains(y) else { break }

    up = map[y][origin.x]
    offset += 1
  } while up == .None

  offset = 1

  var upRight: MapTile? = nil
  repeat {
    let y = origin.y - offset
    let x = origin.x + offset

    guard map.indices.contains(y), map[0].indices.contains(x) else { break }

    upRight = map[y][x]
    offset += 1
  } while upRight == .None

  offset = 1

  var left: MapTile? = nil
  repeat {
    let x = origin.x - offset

    guard map[0].indices.contains(x) else { break }

    left = map[origin.y][x]
    offset += 1
  } while left == .None

  offset = 1

  var right: MapTile?
  repeat {
    let x = origin.x + offset

    guard map[0].indices.contains(x) else { break }

    right = map[origin.y][x]
    offset += 1
  } while right == .None

  offset = 1

  var downLeft: MapTile?
  repeat {
    let y = origin.y + offset
    let x = origin.x - offset

    guard map.indices.contains(y), map[0].indices.contains(x) else { break }

    downLeft = map[y][x]
    offset += 1
  } while downLeft == .None

  offset = 1

  var down: MapTile?
  repeat {
    let y = origin.y + offset

    guard map.indices.contains(y) else { break }

    down = map[y][origin.x]
    offset += 1
  } while down == .None

  offset = 1

  var downRight: MapTile?
  repeat {
    let y = origin.y + offset
    let x = origin.x + offset

    guard map.indices.contains(y), map[0].indices.contains(x) else { break }

    downRight = map[y][x]
    offset += 1
  } while downRight == .None

  return [upLeft, up, upRight, left, right, downLeft, down, downRight]
    .filter { $0 != nil }
    .map { $0! }
    .filter { $0 != .None }
}

fileprivate func applyHumanBehavior(map: [[MapTile]]) -> [[MapTile]] {
  var newMap = map // pretty sure Swift will copy in this instance

  for (y, line) in map.enumerated() {
    for (x, _) in line.enumerated() {
      let seat = map[y][x]
      let count = seenSeats(in: map, from: (x: x, y: y))
        .map { $0.isTakenSeat }
        .reduce(0) { $0 + ($1 ? 1 : 0) }

      if seat == MapTile.EmptySeat && count == 0 {
        newMap[y].replaceSubrange(x..<x+1, with: [MapTile.TakenSeat])
        continue
      }

      if seat == MapTile.TakenSeat && count >= 5 {
        newMap[y].replaceSubrange(x..<x+1, with: [MapTile.EmptySeat])
        continue
      }
    }
  }

  return newMap
}

func day11_2(input: String) -> Int {
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

