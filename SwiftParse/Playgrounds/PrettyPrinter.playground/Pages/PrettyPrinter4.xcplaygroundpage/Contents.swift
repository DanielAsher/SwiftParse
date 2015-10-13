//: [Previous](@previous)

//: [Previous](@previous)

import Foundation

enum Doc {
    case Nil
    indirect case Text(String, Doc)
    indirect case Line(Int, Doc)
    indirect case Union(Doc, Doc)
}


extension Doc : DocType {
    static var zero : Doc { return Doc.Nil }
    static func text(str: String) -> Doc {
        return Doc.Text(str, Doc.Nil)
    }
    static var line : Doc { return Doc.Line(0, Doc.Nil) }
    static func nest(i: Int) -> Doc -> Doc {
        return { doc in 
            switch doc {
            case let .Text(str, d): return Doc.Text(str, nest(i)(d) )
            case let .Line(j, d): return Doc.Line(i+j, nest(i)(d) )
            case let .Union(lhs, rhs): return Doc.Union(nest(i)(lhs), nest(i)(rhs))
            case .Nil: return Doc.Nil
            }
        }
    }
    func layout() -> String {
        switch self {
//        case .Text(let s, let .Union(x, y)): 
//            return s + x.layout() + "\n" + s + y.layout()
        case let .Text(s, x): return s + x.layout()
        case let .Line(i, x): 
            let prefix = "\n" + String(count: i, repeatedValue: Character(" "))
            return prefix + x.layout()
        case let .Union(lhs, rhs): return lhs.layout() + "\n" + rhs.layout()
        case .Nil: return ""
        }
    }
}

func <§> (lhs: Doc, rhs: Doc) -> Doc {
    switch (lhs, rhs) {
    case (.Nil, .Nil):  return .Nil
    case (_, .Nil):     return lhs
    case (.Nil, _):     return rhs
    case (let .Union(x, y), let z): return .Union(x <§> z, y <§> z)
    case (let x, let .Union(y, z)): return .Union(x <§> y, x <§> z)
    case (let .Text(s, x), _):      return .Text(s, x <§> rhs)
    case (let .Line(i, x), _):      return .Line(i, x <§> rhs)
    default: return .Union(lhs, rhs)
    }
}

infix operator <|> { associativity left }

func <|> (lhs: Doc, rhs: Doc) -> Doc {
    switch (lhs, rhs) {
    case (let .Union(x, y), let z): return .Union(x <§> z, y <§> z)
    case (let x, let .Union(y, z)): return .Union(x <§> y, x <§> z)
    default: return Doc.Union(lhs, rhs)
    }
}

func group(doc: Doc) -> Doc {
    switch doc {
    case .Nil:  return .Nil
    case let .Line(i, x):   return .Union(.Text(" ", flatten(x)), .Line(i, x))
    case let .Text(s, x):   return .Text(s, group(x))
    case let .Union(x, y):  return .Union(group(x), y)
    }
//     return flatten(doc) <§> doc
}

func flatten(doc: Doc) -> Doc {
    switch doc {
    case .Nil: return .Nil
    case let .Line(_, x):   return .Text(" ", flatten(x))
    case let .Text(s, x):   return .Text(s, flatten(x))
    case let .Union(x, _):  return flatten(x)
    }
}

func best(w: Int, _ k: Int, _ doc: Doc) -> Doc {
    switch doc {
    case .Nil: return .Nil
    case let .Line(i, x): return .Line(i, best(w, i, x))
    case let .Text(s, x): return .Text(s, best(w, k + s.characters.count, x))
    case let .Union(x, y): return better(w, k, best(w, k, x), best(w, k, y))
    }
}

func better(w: Int, _ k: Int, _ x: Doc, _ y: Doc) -> Doc {
    if fits(w-k, doc: x) {
        return x
    } else {
        return y
    }
}

func fits(w: Int, doc: Doc) -> Bool {
    switch doc {
        case _ where w < 0: return false
        case .Nil: return true
        case let .Text(s, x): return fits(w - s.characters.count, doc: x)
        case .Line: return true
        default:    return false
    }
}

func pretty(w: Int, doc: Doc) -> String {
    return best(w, 0, doc).layout()
}

let a = Doc.text("hello") <§> Doc.line <§> Doc.text("a")
print("\na:", a, terminator: "\n")
//print("a.layout:", "\n\(a.layout())", terminator: "\n")
//
//let ag = group(a)
//print("\nag:", ag, terminator: "\n")
//print("ag.layout:", ag.layout(), terminator: "\n")
//
//let b = group(a <§> Doc.line <§> Doc.text("b"))
//print("\nb:", b, terminator: "\n")
//print("b.layout:", b.layout(), terminator: "\n")

let g1 = 
group(
    group(
        group(Doc.text("hello") <§> Doc.line <§> Doc.text("a"))
            <§> Doc.line <§> Doc.text("b"))
        <§> Doc.line <§> Doc.text("c"))

//print("\ng1:", g1, terminator: "\n")
print("g1 pretty:")
print(pretty(12, doc: g1), terminator: "\n")




print("Finished :)")

//: [Next](@next)


//: [Next](@next)
