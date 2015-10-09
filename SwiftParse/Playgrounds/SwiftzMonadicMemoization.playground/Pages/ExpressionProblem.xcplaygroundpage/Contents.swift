//: [Previous](@previous)

protocol Valuable {
//    typealias A
    func evaluate() -> Double
}
// Closed for extension.
enum Expr {
    case Const(Double)
    indirect case Add(Expr, Expr)
}

extension Expr : Valuable {
//    typealias A = Expr
    func evaluate() -> Double {
        switch self {
        case Expr.Const(let x): return x
        case Expr.Add(let l, let r): return l.evaluate() + r.evaluate()
        }
    }
}

extension Bool : Valuable {
    func evaluate() -> Double {
        return self ? 1 : 0
    }
}


let a = Expr.Add(.Const(2), .Add(.Const(3), .Const(4)))
a.evaluate()
true.evaluate()
//extension Valuable where A == Expr {
//    func evaluate() -> Double {
//        switch self {
//            case Expr.Const(let x): return x
//            case Expr.Add(let l, let r): return l.evaluate() + r.evaluate()
//        }
//    }
//}


print("Finished")

//: [Next](@next)
