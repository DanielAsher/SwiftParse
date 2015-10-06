//: [Previous](@previous)

import Swiftz

public struct Fib<T: Monad where T.A == Int> : Functor {
    
    public func fmap(f: T.A -> T.B) -> T {
        return fmap(f)
    }
    
    static func fib(n: T.A) -> T {
        switch n {
        case 0: return T.pure(0)
        case 1: return T.pure(1)
        case let n:
            let p = fib(n-2).fmap //{ (a:T.A) in a }
            return fib(n-2)//.fmap { a in fib(n-1).fmap { b in T.pure(a + b) } }
            //        return fib(n-2).bind { a in 
            //            return fib(n-1).bind { b in 
            //                T.pure(a + b) } 
            //        }
        }
    }
}

var b : Fib<Optional<Int>>.FB = Optional.Some(0)
var c : Fib<Array<Int>>.FB = [0]

let d = Fib<Optional<Int>>.fib(1)

let e = Fib<Array<Int>>.fib(1)


//let d = Fib<Optional<Double>>()


print("Finished")
//: [Next](@next)
