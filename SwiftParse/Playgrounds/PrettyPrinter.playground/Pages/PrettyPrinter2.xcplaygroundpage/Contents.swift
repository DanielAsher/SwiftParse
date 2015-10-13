//: [Previous](@previous)

import Foundation

enum Doc {
    case Nil
    indirect case Text(String, Doc)
    indirect case Line(Int, Doc)
}

extension Doc : DocType {
    static var zero : Doc { return Doc.Nil }
    static func text(str: String) -> Doc {
        return Doc.Text(str, Doc.Nil)
    }
    static var line : Doc { return Doc.Line(0, Doc.Nil) }
    static func nest(n: Int) -> Doc -> Doc {
        return { doc in switch doc {
            case let .Text(str, d): return Doc.Text(str, nest(n)(d) )
            case let .Line(n2, _): return Doc.Line(n+n2, nest(n)(doc) )
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
        case .Nil: return ""
        }
    }
}

func <§> (lhs: Doc, rhs: Doc) -> Doc {
    switch lhs {
    case let .Text(str, doc): return Doc.Text(str, doc <§> rhs)
    case let .Line(i, x): return Doc.Line(i, x <§> rhs)
    default: return Doc.Nil
    }
}


let tree1 = 
    Doc.Text("bbbbb[", 
    Doc.Line(2, Doc.Text("ccc,", 
    Doc.Line(2, Doc.Text("dd", 
    Doc.Line(0, Doc.Text("]", Doc.Nil)))))))
    
print(tree1, "\n")
print(tree1.layout(), "\n")

print("Finished :)")

//: [Next](@next)
