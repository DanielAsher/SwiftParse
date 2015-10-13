//: [Previous](@previous)

import Swiftz

struct Parser<T> {
    let p: (String, String.Index) throws -> (T, String.Index)
}

enum Error : ErrorType { case E(String) }

func text(char: Character) -> Parser<Character> {
    return Parser<Character> { s, i in
        switch s.match() {
        case let .Cons(x, _) where x == char: 
            return (x, i.successor())
        default:  
            throw Error.E("no match")
        }
    }
}

extension Parser {
    func parseMany() -> Parser<List<T>> {
        let z = List<T>.mempty
        let a = const(z) <^> { (b: Bool) in "\(b)" }
        
        return parseMany()
    }
}



print("Goodbye, playground :)")

//: [Next](@next)
