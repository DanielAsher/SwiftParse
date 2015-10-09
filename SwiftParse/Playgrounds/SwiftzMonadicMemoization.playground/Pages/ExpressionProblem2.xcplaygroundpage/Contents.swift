//: [Previous](@previous)

import Foundation

protocol Expr {
    typealias A
    typealias B
    func evaluate() -> Double
}

enum Const { case Const(Double) }

// Is there a way to remove the generic type constraint `Pretty` ?
enum Add<T: Pretty, U: Pretty> { case Add(T, U) }

extension Const : Expr {
    typealias A = Double
    typealias B = Any
    func evaluate() -> Double {
        switch self { case .Const(let x): return x }
    }
}

extension Add where T: Expr, U: Expr {
    typealias A = T
    typealias B = U
    func evaluate() -> Double {
        switch self { 
        case .Add(let a, let b): return a.evaluate() + b.evaluate() 
        }
    }
}

extension Add : Expr {}

enum Mul<T: Expr, U: Expr> {
    case Mul(T, U)
}

extension Mul where T: Expr, U: Expr {
    typealias A = T
    typealias B = U
    func evaluate() -> Double {
        switch self { 
        case .Mul(let a, let b): return a.evaluate() * b.evaluate() 
        }
    }
}
extension Mul : Expr {}

protocol Pretty : Expr {
    func pretty() -> String
}

extension Const : Pretty {
    func pretty() -> String {
        return "\(self.evaluate())"
    }
}

extension Add where T: Pretty, U: Pretty {
    func pretty() -> String {
        switch self { 
        case .Add(let a, let b): 
            return "(" + a.pretty() + " + " + b.pretty() + ")"
        }
    }
}
extension Add : Pretty {}
//extension Add : Pretty {
//    func pretty() -> String {
//        return self.pretty()
//    }
//}

// Add(Const.Const(2.0), Add<Const, Const>.Add(Const.Const(3.0), Const.Const(4.0)))
let a0 = Add.Add(Const.Const(2), Const.Const(4))

let a = Add.Add(Const.Const(2), Add.Add(Const.Const(3), Const.Const(4)))

let b = a.evaluate()
let c = a.pretty()


print("Finished")

//: [Next](@next)


//: [Next](@next)
