//: [Previous](@previous)

import Swiftz

struct Fib<A, B, FB> : Functor {
    
    func fmap(f: Int -> Int) -> Fib {
        return fmap(f)
    }
    
    init<M: Monad where M.A == A, M.B == B, M.FB == FB>(_ t:M) {
    }
    
}

let a = Fib(Optional(0.0))

print("Finished")

//: [Next](@next)
