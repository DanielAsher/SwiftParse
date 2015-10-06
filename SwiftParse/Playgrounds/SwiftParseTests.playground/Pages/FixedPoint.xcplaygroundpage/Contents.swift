//: [Previous](@previous)

import Foundation
import Swiftz

var str = "Hello, playground"

//func fix<A, B>(f : (A -> B) -> A -> B) -> A -> B {
//    return { x in 
//        f(fix(f))(x) 
//    }
//}

let f : Int -> Int = fix { f in
    return { x in x * x }
}

f(2)
struct Fib2<T: Monad, U: Monad where T.A == Int, U.A == T.A, U.B == T.A, T.FB == U, T.FB.FB == Monad>  {
    static func fib(n : T.A) -> U { //return 
        //        fix { fib in 
        switch n { 
        case 0: return U.pure(0)
        case 1: return U.pure(1)
        case let n:
            let _ = { (a:Int) in { (b:Int) in a + b } }
            
            let f2 : Int -> Int = { a in a-2 }
            let _ =  fib(n-2).fmap(f2) // <*> fib(n-1)
            //            let p = fib(n-2).fmap { $0 } //{ (a:T.A) in a }
            let _ = fib(n-2).bind { a in fib(n-2).bind { b in U.pure(a + b) } }
            return fib(n-2)//.bind { a in fib(n-2).bind { b in U.pure(a + b) } }
//            return fib(n-2)//.bind { a in fib(n-1).bind { b in T.pure(a + b) } }
        }
        //        }
    }
}

struct Fib1<T: Monad where T.A == Int, T.B == Int, T.FB == T> {
    init(u: T) {
        
    }
    func fib(n: T.A) -> T.FB {
        switch n {
            case 0: return T.FB.pure(0)
            case 1: return T.FB.pure(1)
            case let n: return self.fib(n-2).bind { a in 
                        return self.fib(n-1).bind { b in 
                        T.FB.pure(a + b) } }
        }
    }
}


//struct Fib<T: Monad where T.A == Int> : Functor, Pointed {
//    typealias A = Int
//    typealias B = Int
//    typealias FB = T.FB
//    static func pure(_: Fib.A) -> Fib {
//        return Fib()
//    }
//    func fmap(f: A -> B) -> FB {
//        let ret = fmap(f)
//        return ret
//    }
//    
//    func fib(n: A) -> T {
//        switch n {
//        case 0: return T.pure(0)
//        case 1: return T.pure(1)
//        case let n: return self.fib(n-2).bind { a in 
//            return self.fib(n-1).bind { b in 
//                T.pure(a + b) } }
//        }
//    }
//
//}



//struct Fib3<T: Monad where T.A == Int> : Functor, Pointed {
//    typealias A = T.A 
//    typealias B = T.B
//    typealias FB = T
//    static func pure(_: A) -> Fib3 {
//        return Fib3()
//    }
//    func fmap(f: A -> B) -> FB {
//        let ret = fmap(f)
//        return ret
//    }
//    
//    func fib(n: A) -> FB {
//        switch n {
//        case 0: return FB.pure(0)
//        case 1: return FB.pure(1)
//        case let n: 
//            
//            return self.fib(n-2).bind { a in 
//                return self.fib(n-1).bind { b in 
//                    FB.pure(a + b) } 
//            }
//        }
//    }
//}

protocol FibType : Functor {
}

//struct Fib <T: Monad where T.A == Int, T.B == Int> : Functor {
//    typealias A = T.A
//    typealias B = T.B
//    typealias FB = Monad
//    func fmap(f: Int -> Int) -> T {
//           return T.pure(f(0))
//    }
//    
//    static func fib(n: T.A) -> FB {
//        switch n {
//        case 0: return T.pure(0)
//        case 1: return T.pure(1)
//        default:
//            let f1 : T = fib(n - 2)//.fmap { $0 }
////            let f2 = f1.fmap { (a:T.A) in a }
//            let f2 : T = fib(n - 1)
////            let f5 = f1.bind { a in f3.bind { b in T.pure(a + b) }}
////            let f4 = f3.bind { a in f2 }
//            return f1.bind { a in f2.bind { b in T.pure(a + b) }} // .bind { a in T.pure(a) }
//        }
////        case let n: 
////            
////            return fib(n-2).bind { a in 
////                return fib(n-1).bind { b in 
////                    T.FB.pure(a + b) } 
////            }
////        }
//    }
//}

//func fib<T: Monad where T.A == Int, T.B == Int, T.FB == T>(n: T.A) -> T {
//    switch n {
//    case 0: return T.pure(0)
//    case 1: return T.pure(1)
//    default:
//        let f1 : T = fib(n - 2)//.fmap { $0 }
//        //            let f2 = f1.fmap { (a:T.A) in a }
//        let f2 : T = fib(n - 1)
//        //            let f5 = f1.bind { a in f3.bind { b in T.pure(a + b) }}
//        //            let f4 = f3.bind { a in f2 }
//        return f1.bind { a in f2.bind { b in T.pure(a + b) }}     
//    }
//}

//let q = Fib<List<Int>>.fib(4) //.runIdentity

//let w : Identity<Int> = fib(2)

let unwrap = { (x:Identity<Int>) in x.runIdentity }

let zero = Identity(0)
let g = zero.fmap { Optional($0) }
let h = zero.bind {  a in
    Identity.pure(a) }

//let b = Fib1
//let c = Fib1(u: zero)

//let a = Fib<Optional<Int>>.fib



//id.
//let r2 = (0...10).map(Fib<Identity<Int>>.fib)

//func Y<A,B>(f: (A -> B) -> A -> B) -> A -> B {
//    return f(Y(f))
//}
//
//let fY : Int -> Int = Y { fY in
//    return { x in x * x }
//}
//let y = fY(2)

print("Finished")

//: [Next](@next)
