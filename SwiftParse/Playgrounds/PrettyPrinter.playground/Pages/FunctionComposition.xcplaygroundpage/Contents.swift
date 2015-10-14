//: [Previous](@previous)

import Swiftz

let f : [Int] -> Int = { $0.reduce(0, combine: (+)) }
let g : [String] -> [Int] = { $0.map{Int($0) ?? 0} }
let h : String -> [String] = { $0.componentsSeparatedByString(" ") }

let j = f • g • h
let k = h >>> g >>> f
j("1 2 2  3 4    5")

var str = "Goodbye, playground"

//: [Next](@next)
