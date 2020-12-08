import Foundation

enum Instruction: String {
  case acc = "acc"
  case jmp = "jmp"
  case nop = "nop"
}

func day8_1(input: String) -> (Int, Bool) {
  let program: [(Instruction, Int)] = input
    .components(separatedBy: "\n")
    .map { $0.components(separatedBy: " ") }
    .filter { $0.count >= 2 }
    .map { pair in 
      let instr = Instruction(rawValue: pair[0])
      let x = Int(pair[1])
      return (instr!, x!)
    }
  var index = program.startIndex
  var lineVisitedCount: [Int: Int] = [:]
  var acc = 0
  var inf = false

  while true {
    let count = (lineVisitedCount[index] ?? 0) + 1
    lineVisitedCount[index] = count

    if count > 1 {
      inf = true
      break
    } else if index >= program.count {
      return (acc, false)
    }

    let (instr, x) = program[index]
    switch instr {
    case .acc:
      acc += x
    case .jmp:
      index = program.index(index, offsetBy: x)
      continue
    case .nop:
      break
    }

    index = program.index(index, offsetBy: 1)
  }

  return (acc, inf)
}

func day8_2(input: String) -> Int {
  let nops = (try! NSRegularExpression(pattern: "nop")).matches(in: input, options: [], range: NSRange(location: 0, length: input.utf8.count))

  for nop in nops {
    print("nop: \(nop)")
    let copy = (input.copy() as! String).replacingCharacters(in: nop.range, with: "jmp")
    let (acc, inf) = day8_1(input: copy)
    if !inf { return acc }
  }

  let jmps = (try! NSRegularExpression(pattern: "jmp")).matches(in: input, options: [], range: NSRange(location: 0, length: input.utf8.count))

  for jmp in jmps {
    let copy = (input.copy() as! String).replacingCharacters(in: jmp.range, with: "nop")
    let (acc, inf) = day8_1(input: copy)
    if !inf { return acc }
  }

  return -1
}
