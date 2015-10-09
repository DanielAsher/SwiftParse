//: [Previous](@previous)

import Swiftz
func f<T: Monad, U: Monad where T.A == Int, T.FB == U, U.A == Int>(n: T, z: U) -> T.FB {
    let a₂ = n.bind { a in U.pure(a) }
    return a₂ 
}

//let a = f(Optional(1), z: Optional(1)) // runtime error EXC_BAD_ACCESS

func square(x: Int) -> Int {
    return x * x
}

let sq : Int -> Int = { $0 * $0 }

let mis : Optional<Int> = 3

// Here we see the target type of A -> B? is covariant
let m = mis
    .bind { sq($0) }

let m₁ = mis
    .fmap { sq($0) }

let c : (Int -> Int) -> Int? = mis.fmap
//let d = c • c
struct Funct<A, B, FB> : Functor {
    
    func fmap(f: Int -> Int) -> Funct {
        return fmap(f)
    }
    
    init<M: Monad where M.A == A, M.B == B, M.FB == FB>(_ t:M) {
    }
    
}

let d = Funct(m₁)

protocol Λ {
    typealias A
    typealias Pair = (A, A)
    
    func map<A>() -> (A, A)
}

protocol Connect {
    func connectOverTCP(host: String) -> Optional<[String]>
    func handshake(socket: String) -> Optional<[Bool]>
    func connect(host: String) -> Optional<[Bool]>
}

extension Connect {
    func connect(host: String) -> Optional<[Bool]> {
        let defSocket = connectOverTCP(host)
        return defSocket.bind { xs in [xs.first != nil ? true : false] }
    }
}

enum Fix<T: Monad where T.A == Fix> {
    indirect case In(Fix)
}

print("Finished")
//: [Next](@next)








