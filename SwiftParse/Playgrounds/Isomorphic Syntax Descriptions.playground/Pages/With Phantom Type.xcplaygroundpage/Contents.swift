//: Invertible Syntax Descriptions

//: http://www.informatik.uni-marburg.de/~rendel/unparse/rendel10invertible.pdf

import Swiftz

class Iso<T,U,V> {
    let to   : T -> Optional<U>
    let from : U -> Optional<T>
    
    init(to: T -> Optional<U>, from: U -> Optional<T>) {
        self.to = to
        self.from = from
    }
}

func • <T,U,V>(c: Iso<U,V,V>, c2: Iso<T,U,V>) -> Iso<T,V,V> {
    
    return Iso<T,V,V>(
        to:     { t in c2.to(t).bind(c.to) }, 
        from:   { v in c.from(v).bind(c2.from) }
    )
}

func >>> <T,U,V>(c: Iso<T,U,V>, c2:Iso<U,V,V>) -> Iso<T,V,V> {
    return Iso<T,V,V>(
        to: { t in c.to(t).bind(c2.to) }, 
        from: { v in c2.from(v).bind(c.from) }
    )
}

func <<< <T,U,V>(c: Iso<U,V,V>, c2:Iso<T,U,V>) -> Iso<T,V,V> {
    return Iso<T,V,V>(
        to: { t in c2.to(t).bind(c.to) }, 
        from: { v in c.from(v).bind(c2.from) }
    )
}

extension Iso : Category {
    typealias A = T
    typealias B = U
    typealias C = V
    typealias CAA = Iso<A,A,C>
    typealias CBC = Iso<B,C,C>
    typealias CAC = Iso<A,C,C>
    
    static func id() -> Iso<T,T,V> {
        return Iso<T,T,V>(to: { t in .Some(t) },
            from: { t in .Some(t) }
        )
    }
}

protocol IsoFunctor {
    typealias A
    typealias B
    typealias C
    typealias FA = K1<A>
    typealias FB = K1<B>
    func <^> (iso: Iso<A,B,C>, a: FA) -> FB
}

func <^> <T,U,V>(iso: Iso<T,U,V>, a: Optional<T>) -> Optional<U> {
    return a.bind { a in iso.to(a) }
}
infix operator >^< { associativity left }
func >^< <T,U,V>(a: Optional<T>, iso: Iso<T,U,V>) -> Optional<U> {
    return .None
}
protocol ProductFunctor {
    typealias A
    typealias B
    typealias FA  = K1<A>
    typealias FB  = K1<B>
    typealias FAB = K1<(A, B)>
    func <*> (a: FA, b: FB) -> FAB
}
infix operator <|> { associativity left}
protocol Alternative {
    typealias A
    typealias FA = K1<A>
    func <|> (a: FA, b: FA) -> FA
    static var empty : FA { get }
}

protocol Syntax : IsoFunctor, ProductFunctor, Alternative {
    typealias DA    = K1<A>
    typealias DB    = K1<B>
    typealias DLA   = K1<[A]>
    typealias DChar = K1<Character>
    static func pure(a: A) -> DA
    static func pureB(a: B) -> DB
    static var token : DChar {get}
    func many(p: DA) -> DLA
    func bind(k: A -> DB) -> DB
    func map(iso: Iso<A, B, B>, da: DA) -> DB
    static func aToB(a: A) -> B 
}



//func cons<T,U,V>() -> Iso<T,U,V> {
//    
//}

extension Syntax where DA : Syntax, DB : Syntax {

    var nill : Iso<A,[A],A> {
        return Iso<A,[A],A> (to: { t in Optional<[A]>.None}, from: { u in Optional<A>.None }) 
    } 
    var cons : Iso<(A,[A]),[A],A> {
        return Iso<(A,[A]),[A],A>(
            to: { (x, xs) in [x] + xs }, 
            from: { switch $0.match {
                case .Nil:              return .None
                case let .Cons(x, xs):  return .Some((x, xs))
                }
            } )
    }
    
//    func bind(da: DA, k: A -> DB) -> DB {
//        return da
//    }
    
//    func map(iso: Iso<A, B, B>, da: DA) -> DB {
//        let f : DB = da.bind { a in DB.pureB(DA.aToB(a)) }
//        return f
////        return bind(da) { a in Self.pureB(iso.to(a)) } 
//    }
    
    func many(p: DA) -> DLA {
        let _ = nill <^> .None 

        let _ = { x in Self.pure(x) } 
//        let b = p <*> many(p)
        return many(p)
    }
}

//extension Iso {
//    func map<T,U,V>(a: Optional<T>) -> Optional<U> {
//        let t : T = a!
//        let u : Optional<U> = self.to(t)
//        return u
//    }
//}

print("Finished :)")
