import Foundation

fileprivate enum Direction: Int {
  case North = 0
  case East = 90
  case South = 180
  case West = 270

  func apply(action: Action, units: Int) -> Direction {
    guard action == .Left || action == .Right else { return self }
    let multiple = action == .Left ? -1 : 1

    var rawValue = (self.rawValue + multiple * units) % 360
    if rawValue < 0 { rawValue += 360 }

    return Direction(rawValue: rawValue)!
  }
}

fileprivate typealias State = (east: Int, north: Int, angle: Direction)

fileprivate enum Action: Character {
  case North = "N"
  case South = "S"
  case East = "E"
  case West = "W"
  case Left = "L"
  case Right = "R"
  case Forward = "F"
}

fileprivate extension Direction {
  var action: Action {
    switch self {
    case .North: return .North
    case .East: return .East
    case .South: return .South
    case .West: return .West
    }
  }
}

fileprivate extension Action {
  func apply(units: Int, to _state: State) -> State {
    var state = _state

    switch self {
    case .North: state.north += units
    case .South: state.north -= units
    case .East: state.east += units
    case .West: state.east -= units
    case .Left: state.angle = state.angle.apply(action: self, units: units)
    case .Right: state.angle = state.angle.apply(action: self, units: units)
    case .Forward: return state.angle.action.apply(units: units, to: state)
    }

    return state
  }
}

func day12(input: String) -> Int {
  let lines = input.components(separatedBy: "\n").dropLast()
  var state: State = (north: 0, east: 0, angle: .East)

  for line in lines {
    let action = Action(rawValue: line.first!)!
    let units = Int(line.substring(from: line.index(line.indices.first!, offsetBy: 1)))!

    state = action.apply(units: units, to: state)
  }

  return abs(state.east) + abs(state.north)
}
