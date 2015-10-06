//: [Previous](@previous)

import Swiftz

enum OptionalExt<T,U> {
    case None
    case Some(T)
}

extension OptionalExt : Functor {
    func fmap(f: T -> U) -> Optional<U> {
        switch self {
        case .None: return .None
        case .Some(let t): return .Some(f(t))
        }
    }  
}

struct Fib<S, T, FT where FT : Monad> : Functor {
    let n : Int
    func fmap(f : Int -> Int) -> Fib {
        return Fib(n: f(n))
    }
    
    func mFib<T: Monad where T.A == Int, T.B == Int, T.FB == Optional<Any>>(n: Int, source:T) -> T {
        
        switch n {
        case 0: return T.pure(0)
        case 1: return T.pure(1)
        case let n:
            let a = mFib(n-2, source: source).bind { a in Optional.Some(a) }
            return mFib(n-2, source: source)
            //                    .bind { a in return mFib(n-1, type: type)
            //                      .bind { b in T.pure(a + b) }
            //                    } 
            
        }
    }
  

}


print("Finished")
//: [Next](@next)
