//: [Previous](@previous)

import Foundation
//import Swiftx

var str = "Hello, playground"

func fix<A, B>(f : (A -> B) -> A -> B) -> A -> B {
    return { x in 
        f(fix(f))(x) 
    }
}

let f : Int -> Int = fix { f in
    return { x in x * x }
}

f(2)
struct Fib<T>  {
    static var fib : Int -> Int { return 
        fix { fib in 
            return {
                switch $0 { 
                case 0: return 0
                case 1: return 1
                case let n: return fib(n-2) + fib(n-1)
                }
            }
        }
    }
}


let r2 = (0...10).map(Fib<Int>.fib)

func Y<A,B>(f: (A -> B) -> A -> B) -> A -> B {
    return f(Y(f))
}
//
//let fY : Int -> Int = Y { fY in
//    return { x in x * x }
//}
//let y = fY(2)

print("Finished")

//: [Next](@next)
