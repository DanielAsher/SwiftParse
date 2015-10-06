//: [Previous](@previous)


import Swiftz

protocol OptionalExt : Functor {
    typealias FB = Optional<B>
}

struct Fib4<M: Monad where M.A == Int, M.FB == M> : Functor {
    
    typealias FB = M
    let n : M.A
    
    func fmap(f: M.A -> M.A) -> M {
        return M.pure(f(n))
    }
    
    static func fib(n: M.A) -> M {
        switch n {
        case 0: return M.pure(0)
        case 1: return M.pure(1)
        case let n:
            return fib(n-2).bind { a in 
                return fib(n-1).bind { b in 
                    M.pure(a + b)
                } 
            }
        }
    }
}

//var h : Fib4<Optional<Int>>.FB = Optional.Some(0)

print("Finished")
//: [Next](@next)
