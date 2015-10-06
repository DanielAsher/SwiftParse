//: Playground - noun: a place where people can play

import Swiftz

func fib<T: Monad where T.A == Int, T.B == Int, T.FB == T>(n: T.A) -> T {
    switch n {
    case 0: return T.pure(0)
    case 1: return T.pure(1)
    case let n:
        // ERROR: value of type '(Int) -> T' has no member 'A'
        return fib(n-2).fmap { a in fib(n-1).fmap { b in T.pure(a + b) } }
//        return fib(n-2).bind { a in 
//            return fib(n-1).bind { b in 
//                T.pure(a + b) } 
//        }
    }
}

//let a : Optional<Int> = fib(3)  
