//: [Previous](@previous)

//: String interpolation only performed when `greeting` is called.

import Swiftz

func defered(@autoclosure(escaping) str: () -> String) -> () -> String {
    return str
}
func name() -> String {
    return "Daniel"
}

let greeting = 
    defered("Hello \(name()). ") 
    >>> { $0 + "How are you?"} 

greeting()

//: [Next](@next)
