//: [Previous](@previous)

import Swiftz

enum Expr {
    case I(Int)
    case B(Bool)
    indirect case Add(Expr, Expr)
    indirect case Mul(Expr, Expr)
    indirect case Eq(Expr, Expr)
}

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
            default: return nil
        }
    }
}

let a = Expr.Add(Expr.I(3), Expr.I(4)).eval()

func + (lhs: Expr, rhs: Expr) -> Expr {
    return Expr.Add(lhs, rhs)
}

func * (lhs: Expr, rhs: Expr) -> Expr {
    return Expr.Mul(lhs, rhs)
}

let b = (.I(3) + .I(4)) * .I(4)
b.eval()

let impossible = Expr.Add(.I(5), .B(true))
impossible.eval() // nil





//: [Next](@next)
