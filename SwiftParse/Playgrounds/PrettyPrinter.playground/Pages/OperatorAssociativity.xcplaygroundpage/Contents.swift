//: [Previous](@previous)

import Foundation

infix operator <=> { associativity left }

enum Term { 
    indirect case Minus(Term, Term)
    case Var(Int)
}

func <=> (lhs: Int, rhs: Int) -> Term {
    lhs
    rhs
    return Term.Minus(Term.Var(lhs), Term.Var(rhs))
}
func <=> (lhs: Term, rhs: Int) -> Term {
    lhs
    rhs
    return Term.Minus(lhs, Term.Var(rhs))
}
func <=> (lhs: Int, rhs: Term) -> Term {
    lhs
    rhs
    return Term.Minus(Term.Var(lhs), rhs)
}
func <=> (lhs: Term, rhs: Term) -> Term {
    lhs
    rhs
    return Term.Minus(lhs, rhs)
}

let a = 1 <=> 2 <=> 3 <=> 4
// left associative
// Minus(Term.Minus(Term.Minus(Term.Var(1), Term.Var(2)), Term.Var(3)), Term.Var(4))

// right associative
// Minus(Term.Var(1), Term.Minus(Term.Var(2), Term.Minus(Term.Var(3), Term.Var(4))))

var str = "Hello, playground"

//: [Next](@next)
