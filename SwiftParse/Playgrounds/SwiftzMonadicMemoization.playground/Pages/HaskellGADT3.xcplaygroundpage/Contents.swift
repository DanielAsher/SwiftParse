//: [Previous](@previous)

enum _Expr<T> {
    case Nil
    case I(Int)
    case B(Bool)
    indirect case Add(_Expr, _Expr)
    indirect case Mul(_Expr, _Expr)
    indirect case Eq(_Expr, _Expr)
}


enum Expr<T> : CustomStringConvertible {
    typealias ExprType = T
    case I(Int -> _Expr<Int>)
    case B(Bool -> Expr<Bool>)
    case Add(Expr<Int> -> Expr<Int> -> Expr<Int>)
    case Mul(Expr<Int> -> Expr<Int> -> Expr<Int>)
    case Eq(Expr<Int> -> Expr<Int> -> Expr<Bool>)
    case Nil
    
    var description : String {
        switch self {
        case .I(let f): return "\(f(0))"
        default: return ""
        }
    }
    
//    func eval() -> T? {
//        switch self {
//        
////            case .I: return Optional.Some(0)
//            // ERROR: cannot convert return expression of type 'Expr<Int>' to return type 'T'
//            default: return nil
//        }
//    }
}

extension Expr where Expr<T>.ExprType : IntegerLiteralConvertible {
    func eval() -> Int {
        return 0
    }
}


let a = Expr<Int>.I { a in _Expr.I(5) }

print("Finished")

//: [Next](@next)
