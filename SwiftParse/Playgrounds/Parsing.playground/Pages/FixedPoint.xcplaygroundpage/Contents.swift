//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let f : Int -> Int = fix { f in
    return { x in x * x }
}

f(2)
//: [Next](@next)
