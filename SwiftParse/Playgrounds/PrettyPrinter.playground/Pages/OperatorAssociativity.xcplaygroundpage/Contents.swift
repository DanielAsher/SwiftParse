//: [Previous](@previous)
infix operator <-> { associativity left }

//enum Term { 
//    indirect case Subtract(Term, Term)
//    case Var(Int)
//}
//protocol TermType {
//    var term : Term { get }
//}
//extension Term : TermType {
//    var term : Term { return self }    
//}
//extension Int : TermType {
//    var term : Term { return Term.Var(self) }
//}
//
//func <-> (lhs: TermType, rhs: TermType) -> Term {
//    return Term.Subtract(lhs.term, rhs.term)
//}

//prefix operator % {}
//prefix func %(s: String) -> DOC {
//    return DOC.text(s)
//}

//func ppr(t: Term) -> DOC {
//    switch t {
//    case .Var(let i): return %"\(i)"
//    case let .Subtract(e1, e2): 
//        return group(
//            ppr(e1) <§> DOC.nest(2)(DOC.line <§> %"-" <§> %" " <§> pprP(e2))
//        )
//    }
//}
//
//func pprP(t: Term) -> DOC {
//    switch t {
//        case .Var(let i): return %"\(i)"
//        case let .Subtract(e1, e2): 
//            return %"(" <§> group(ppr(e1) <§> 
//                DOC.nest(2) (DOC.line <§> %"-" <§> %" " <§> pprP(e2))) <§> %")"
//    }
//}

//let a = 1 <-> 2 //<-> (3 <-> 4)
//print(a)
//print(ppr(a))
//print(best(20, 0, ppr(a)))
//print(pretty(30, x: ppr(a)))

// left associative
// Minus(Term.Minus(Term.Minus(Term.Var(1), Term.Var(2)), Term.Var(3)), Term.Var(4))

// right associative
// Minus(Term.Var(1), Term.Minus(Term.Var(2), Term.Minus(Term.Var(3), Term.Var(4))))



var str = "Goodbye, playground"








//: [Next](@next)
