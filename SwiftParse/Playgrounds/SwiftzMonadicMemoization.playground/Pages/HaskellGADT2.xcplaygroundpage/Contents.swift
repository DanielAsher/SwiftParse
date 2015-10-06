//: [Previous](@previous)

import Swiftz

protocol ExprProtocol {
    typealias ExprType
}

enum Expr<T> : ExprProtocol {
    typealias ExprType = T
    case Nil
    case I(Int)
    case B(Bool)
    indirect case Add(Expr, Expr)
    indirect case Mul(Expr, Expr)
    indirect case Eq(Expr, Expr)
}
extension Expr where Expr<T>.ExprType : IntegerLiteralConvertible {
    init(_ value: ExprType) {
        switch value {
        case let v as Int:      self = I(v)
        case let v as Double:   self = I(Int(v))
        default:                self = Nil
        }
    }
}
extension Expr where Expr<T>.ExprType : BooleanType {
    init(_ value: ExprType) {
        switch value {
        case let v as Bool: 
                    self = B(v)
        default:    self = Nil
        }
    }
}
// error: type 'ExprT' in conformance requirement does not refer to a generic parameter or associated type
extension Expr where Expr<T>.ExprType : IntegerLiteralConvertible {
    static func add(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
        return .Add(lhs, rhs)
    }
    static func mult(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
        return .Mul(lhs, rhs)
    }
    init(value: Int) {
        self = I(value)
    }
}

func + <T where T : IntegerArithmeticType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
    return Expr.Add(lhs, rhs)
}

func * <T where T : IntegerArithmeticType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
    return Expr.Mul(lhs, rhs)
}

func == <T where T : IntegerArithmeticType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
    return Expr.Eq(lhs, rhs)
}
func == <T where T : BooleanType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
    return Expr.Eq(lhs, rhs)
}


Expr(true) == Expr(false)
Expr(1) + Expr(2) == Expr(3) + Expr(4)

// But: https://en.wikibooks.org/wiki/Haskell/GADT
let t = Expr<String>.B(true) // This is still possible


//Expr(1) == Expr(true) // error: binary operator '==' cannot be applied to operands of type 'Expr<Int>' and 'Expr<Bool>'

let c = Expr(1)
let d = Expr<Int>.I(3) + .I(4)

let boolExp = Expr<Bool>.B(true) 
let intExp = Expr<Int>.I(5)
//let impossible = boolExp + intExp // Error: binary operator '+' cannot be applied to operands of type 'Expr<Bool>' and 'Expr<Int>'



// ERROR: same-type requirement makes generic parameter 'T' non-generic
//func add<T where T == NumericType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T>{
//    return lhs
//}
// error: cannot use associated type 'ExprType' outside of its protocol
//func add<T: ExprProtocol where ExprProtocol.ExprType : IntegerArithmeticType>(lhs: Expr<T>, rhs: Expr<T>) -> Expr<T> {
//    return lhs
//}

extension Expr {
    func eval() -> Either<Int, Bool>? {
        switch self {
        case .I(let i): return .Left(i)
        case .B(let b): return .Right(b)
        case .Add(let lhs, let rhs):
            switch (lhs.eval(), rhs.eval()) {
            case (.Some(.Left(let a)), .Some(.Left(let b))):
                return .Left(a + b)
            default: return nil
            }
        case .Mul(let lhs, let rhs):
            switch (lhs.eval(), rhs.eval()) {
            case (.Some(.Left(let a)), .Some(.Left(let b))):
                return .Left(a * b)
            default: return nil
            }
            
        case .Eq(let lhs, let rhs):
            switch (lhs.eval(), rhs.eval()) {
            case (.Some(.Left(let a)), .Some(.Left(let b))):
                return .Right(a == b)
            case (.Some(.Right(let a)), .Some(.Right(let b))):
                return .Right(a && b)
            default: return nil
            }
        case .Nil: return nil
        }
    }
}
//
//let a = Expr.Add(Expr.I(3), Expr.I(4)).eval()
//
//func + (lhs: Expr, rhs: Expr) -> Expr {
//    return Expr.Add(lhs, rhs)
//}
//
//func * (lhs: Expr, rhs: Expr) -> Expr {
//    return Expr.Mul(lhs, rhs)
//}
//
//let b = (.I(3) + .I(4)) * .I(4)
//b.eval()
print("Finished :)")
//: [Next](@next)
