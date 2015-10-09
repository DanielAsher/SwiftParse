//: Invertible Syntax Descriptions

//: http://www.informatik.uni-marburg.de/~rendel/unparse/rendel10invertible.pdf

import Swiftz

struct Iso<T,U> {
    let to   : T -> Optional<U>
    let from : U -> Optional<T>
}

func • <T,U>(c: Iso<U,Any>, c2: Iso<T,U>) -> Iso<T,Any> {

    return Iso<T,Any>(
        to:     { t in c2.to(t).bind(c.to) }, 
        from:   { v in c.from(v).bind(c2.from) }
        )
}

func >>> <T,U>(c: Iso<T,U>, c2:Iso<U,Any>) -> Iso<T, Any> {
    return Iso<T,Any>(
        to: { t in c.to(t).bind(c2.to) }, 
        from: { v in c2.from(v).bind(c.from) }
    )
}

func <<< <T,U>(c: Iso<U,Any>, c2:Iso<T,U>) -> Iso<T, Any> {
    return Iso<T,Any>(
        to: { t in c2.to(t).bind(c.to) }, 
        from: { v in c.from(v).bind(c2.from) }
    )
}

extension Iso : Category {
    typealias A = T
    typealias B = U
    typealias C = Any
    typealias CAA = Iso<A,A>
    typealias CBC = Iso<B,C>
    typealias CAC = Iso<A,C>
    
    static func id() -> Iso<T,T> {
        return Iso<T,T>(to: { t in .Some(t) },
            from: { t in .Some(t) }
            )
    }
    

}
print("Finished :)")
