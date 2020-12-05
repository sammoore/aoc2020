import Foundation

let filePath: String = Bundle.module.path(forResource: "5", ofType: "txt")!
let contents = String(decoding: try! Data(contentsOf: URL(fileURLWithPath: filePath)), as: UTF8.self)

var answer: Any? = day5(input: contents)

guard let answer = answer else {
  fatalError("no match found")
}

print(answer)
