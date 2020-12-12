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

fileprivate typealias State = (east: Int, north: Int, angle: Direction, waypoint: (east: Int, north: Int))

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
  func apply(units _units: Int, to _state: State) -> State {
    var units = _units
    var state = _state

    switch self {
    case .North: state.waypoint.north += units
    case .South: state.waypoint.north -= units
    case .East: state.waypoint.east += units
    case .West: state.waypoint.east -= units
    case .Left, .Right:
      while units != 0 {
        let east = state.waypoint.east
        let north = state.waypoint.north

        if self == .Left {
          state.waypoint.east = (-1 * north)
          state.waypoint.north = east
        } else {
          state.waypoint.east = north
          state.waypoint.north = (-1 * east)
        }

        units -= 90
      }
    case .Forward: 
      while units != 0 {
        state.north += state.waypoint.north
        state.east += state.waypoint.east
        units -= 1
      }
    }

    return state
  }
}

func day12_2(input: String) -> Int {
  let lines = input.components(separatedBy: "\n").dropLast()
  var state: State = (east: 0, north: 0, angle: .East, waypoint: (east: 10, north: 1))

  for line in lines {
    let action = Action(rawValue: line.first!)!
    let units = Int(line.substring(from: line.index(line.indices.first!, offsetBy: 1)))!

    state = action.apply(units: units, to: state)
  }
  
  return abs(state.east) + abs(state.north)
}

