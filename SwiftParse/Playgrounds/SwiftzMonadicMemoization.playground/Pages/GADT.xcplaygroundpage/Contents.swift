//: [Previous](@previous)

//: https://gist.github.com/jckarter/cff22c8b1dcb066eaeb2
//: GADTs === protocol existentials

import Foundation

enum Zero {}
enum Succ<T> {}

struct Unit<T> {}

/*
// Pretend "case Label<T> -> Enum<U>" defines a GADT.
// A GADT like this:
enum ListGADT<T, N> {
case Null<T> -> List<T, Zero>
case Cons<T, N>(T, List<T, N>) -> List<T, Succ<N>>
}
*/

// Is isomorphic to a protocol type whose methods return the type parameters to the GADT
protocol ListProto {
    func null<T>() -> Unit<(T, Zero)>
    func cons<T, N>(_: T, _: ListProto -> Unit<(T, N)>) -> Unit<(T, Succ<N>)>
}

// A GADT constructor === A partially-applied protocol method
/*
let nilGADT: ListGADT = .Nil
let nilProto: ListProtoInstance.Type = { $0.null() }
*/

/* let consGADT: ListGADT = .Cons(1, .Null) */
let nilProto: ListProto -> Unit<(Int, Zero)> = { $0.null() }
let consProto: ListProto -> Unit<(Int, Succ<Zero>)> = { $0.cons(1, nilProto) }

func foo() {}
func bar<T>(x: T) { print("bar \(x)") }

/*
// Pattern matching === implementing the protocol, and applying it to a partial application
switch consGADT {
case .Null: foo()
case .Cons(let first, let rest): bar(first)
}
*/

struct VisitProto: ListProto {
    func null<T>() -> Unit<(T, Zero)> {
        foo()
        return Unit()
    }
    func cons<T, N>(first: T, _ rest: ListProto -> Unit<(T, N)>) -> Unit<(T, Succ<N>)> {
        bar(first)
        return Unit()
    }
}
consProto(VisitProto())

//: [Next](@next)
