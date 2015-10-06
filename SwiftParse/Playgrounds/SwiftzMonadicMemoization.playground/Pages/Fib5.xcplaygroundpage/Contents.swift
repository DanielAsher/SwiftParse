//: [Previous](@previous)

import Swiftz

enum OptionalExt<T,U> {
    case None
    case Some(T)
}

extension OptionalExt : Functor {
    func fmap(f: T -> U) -> OptionalExt<U, U> {
        switch self {
        case .None: return .None
        case .Some(let t): return OptionalExt<U, U>.Some(f(t))
        }
    }  
}

extension OptionalExt : Pointed {
    static func pure(x : T) -> OptionalExt<T, U> {
        return .Some(x)
    }
}

extension OptionalExt : Applicative {
    func ap(f : OptionalExt<T -> U, U>) -> OptionalExt<U, U>	{
        switch (self, f) {
            case (.Some(let x), .Some(let f_)): return OptionalExt<U, U>.Some(f_(x))
            default: return OptionalExt<U,U>.None
        }
    }    
}

extension OptionalExt : Monad {
    func bind(f : T -> OptionalExt<U, U>) -> OptionalExt<U, U> {
        switch self {
        case .Some(let x): return f(x)
        default: return OptionalExt<U,U>.None
        }
    }
}

/// The Identity Functor holds a singular value.
public struct Identity2<T, U> {
    private let unIdentity : () -> T
    
    public init(@autoclosure(escaping) _ aa : () -> T) {
        unIdentity = aa
    }
    
    public var runIdentity : T {
        return unIdentity()
    }
}

public func == <T : Equatable, U>(l : Identity2<T,U>, r : Identity2<T,U>) -> Bool {
    return l.runIdentity == r.runIdentity
}

extension Identity2 : Functor {
    public func fmap(f : T -> U) -> Identity2<U,U> {
        return Identity2<U,U>(f(self.runIdentity))
    }
}

public func <^> <A, B>(f : A -> B, m : Identity2<A, B>) -> Identity2<B, B> {
    return m.fmap(f)
}

extension Identity2 : Pointed {
    public static func pure(x : T) -> Identity2<T, U> {
        return Identity2(x)
    }
}

extension Identity2 : Applicative {
    public typealias FAB = Identity2<T -> U, U>
    
    public func ap(f : Identity2<T -> U, U>) -> Identity2<U, U> {
        return Identity2<U, U>(f.runIdentity(self.runIdentity))
    }
}

public func <*> <T, U>(f : Identity2<T -> U, U>, m : Identity2<T,U>) -> Identity2<U,U> {
    return m.ap(f)
}

extension Identity2 : Monad {
    public func bind(f : T -> Identity2<U, U>) -> Identity2<U,U> {
        return f(self.runIdentity)
    }
}

public func >>- <T, U>(m : Identity2<T,U>, f : T -> Identity2<U,U>) -> Identity2<U,U> {
    return m.bind(f)
}

//func memo<T: Monad>(var dict: Dictionary<T.A, T.FB>) -> (T.A -> T.FB) -> T.A -> T.FB { 
//    return { f in
//        return { a in 
//            if let b = dict[a] { return b } 
//            else { let b = f(a); dict[a] = b; return b }
//        }
//    }
//}

func memo<T: Monad where T.FB == T>(var dict: Dictionary<T.A, T.FB>) -> (T.A -> T.FB) -> T.A -> T.FB { 
    return { f in
        return { a in 
            if let b = dict[a] { return b } 
            else { let b = f(a); dict[a] = b; return b }
        }
    }
}

struct Fib<T: Monad where T.A == Int, T.FB == T> {
    
    static var mFib : Int -> T { 
            return { n in
                switch n {
                case 0: return T.pure(0)
                case 1: return T.pure(1)
                case let n:
                    return self.mFib(n-2).bind { a in 
                            self.mFib(n-1).bind { b in 
                                T.pure(a + b) } } 
                }
            }
    }
    
    static func gmFib(fib: Int -> T) -> Int -> T { 
        return { n in
            switch n {
            case 0: return T.pure(0)
            case 1: return T.pure(1)
            case let n:
                return fib(n-2).bind { a in 
                    fib(n-1).bind { b in 
                        T.pure(a + b) } } 
            }
        }
    }
    
    static func memoFib(a: T.A) -> T.FB {
        let dict = Dictionary<T.A, T.FB>()
        return fix ( memo(dict) • Fib<T>.gmFib ) (a)
    }
}
//
//let a = mFib(1, source: Optional<Int>.None)
//var b = Fib<OptionalExt<Int, Int>>.mFib(10)
//let c = Fib<Identity2<Int, Int>>.mFib(10).runIdentity
var d = Fib<Identity2<Int, Int>>.memoFib(10)





print("Finished :)")
//: [Next](@next)



