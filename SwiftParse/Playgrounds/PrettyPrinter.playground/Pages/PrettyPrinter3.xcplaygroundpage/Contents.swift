//: [Previous](@previous)

import Foundation

enum Doc {
    case Nil
    indirect case Text(String, Doc)
    indirect case Line(Int, Doc)
    indirect case Union(Doc, Doc)
}

infix operator <|> { associativity left }

func <|> (lhs: Doc, rhs: Doc) -> Doc {
    return Doc.Union(lhs, rhs)
}

func flatten(doc: Doc) -> Doc {
    switch doc {
    case .Nil: return .Nil
    case let .Text(txt, doc1):   return .Text(txt, flatten(doc1))
    case let .Line(_, doc1):     return .Text(" ", flatten(doc1))
    case let .Union(lhs, _):  return flatten(lhs)// <|> flatten(rhs) // CHECK!!
    }
}

func group(x: Doc) -> Doc {
    return flatten(x) <|> x
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
    case (.Union(let x, let y), let z): 
        return Doc.Union(x <§> z, y <§> z)
//    case (.Text(let s1, let doc1), .Text(let s2, let doc2)): 
//        return Doc.Text(s1 + s2, doc1 <§> doc2)
//    case (.Line(let i, let doc1), .Line(let j, let doc2)): 
//        return Doc.Line(i+j, doc1 <§> doc2)
    case (.Text(let s, let doc), _): return Doc.Text(s, doc <§> rhs)
    case (.Line(let i, let x), _): return Doc.Line(i, x <§> rhs)

    case (.Nil, .Nil): return Doc.Nil
    case (_, .Nil): return lhs
    case (.Nil, _): return rhs
    default: return Doc.Union(lhs, rhs)
    }
}


let tree1 = 
Doc.Text("bbbbb[", 
    Doc.Line(2, Doc.Text("ccc,", 
        Doc.Line(2, Doc.Text("dd", 
            Doc.Line(0, Doc.Text("]", Doc.Nil)))))))

print(tree1, "\n")
print(tree1.layout(), "\n")

let c = Doc.text("hello") <§> Doc.line <§> Doc.text("a")
//print(c.layout(), "\n")

let g1 = 
        group(
            group(
                group(Doc.text("hello") <§> Doc.line <§> Doc.text("a"))
            <§> Doc.line <§> Doc.text("b"))
        <§> Doc.line <§> Doc.text("c"))

print(g1.layout(), "\n")




print("Finished :)")

//: [Next](@next)
