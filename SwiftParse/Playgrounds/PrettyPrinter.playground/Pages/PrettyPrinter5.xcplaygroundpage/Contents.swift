//: [Previous](@previous)

//import func Swiftz.>>>

enum Doc {
    case Nil
    indirect case Text(String, Doc)
    indirect case Line(Int, Doc)
}

enum DOC {
    case Nil
    indirect case Concat(DOC, DOC)
    indirect case Nest(Int, DOC)
    case Text(String)
    case Line
    indirect case Union(DOC, DOC) 
}

extension DOC : DocType {
    static var zero : DOC { return .Nil }
    static func text(str: String) -> DOC {
        return .Text(str)
    }
    static var line : DOC { return .Line }
    static func nest(n: Int) -> DOC -> DOC {
        return { doc in return .Nest(n, doc) }
    }
    func layout() -> String {
        return ""
    }
}
extension Doc {
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
public enum ArrayMatcher<A> {
    case Nil
    case Cons(A, [A])
}
extension Array {
    /// Destructures a list into its constituent parts.
    ///
    /// If the given list is empty, this function returns .Nil.  If the list is non-empty, this
    /// function returns .Cons(head, tail)
    public var match : ArrayMatcher<Element> {
        if self.count == 0 {
            return .Nil
        } else if self.count == 1 {
            return .Cons(self[0], [])
        }
        let hd = self[0]
        let tl = Array(self[1..<self.count])
        return .Cons(hd, tl)
    }
}

func <§> (lhs: DOC, rhs: DOC) -> DOC {
    return .Concat(lhs, rhs)
}
infix operator <|> { associativity left }
func <|> (lhs: DOC, rhs: DOC) -> DOC {
    return .Union(lhs, rhs)
}
func flatten(d: DOC) -> DOC {
    switch d {
        case .Nil: return .Nil
        case let .Concat(x, y): return .Concat(flatten(x), flatten(y))
        case .Nest(_, let x): return flatten(x)
        case .Text: return d
        case .Line: return .Text(" ")
        case let .Union(x, _): return flatten(x)
    }
}

func rep(ds: [(Int, DOC)]) -> DOC {
    return ds
        .map { DOC.nest($0.0)($0.1) }
        .reduce(.Nil) { $0 <§> $1 }
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
    }
}

func be(w: Int, _ k: Int, _ ds: [(Int, DOC)]) -> Doc {
    switch ds.match {
    case .Nil: return .Nil
    case let .Cons((i, d), z): 
        switch d {
        case .Nil: return be(w, k, z)
        case let .Concat(x, y): return be(w, k, [(i, x), (i, y)] + z)  
        case let .Nest(j, x): return be(w, k, [(i+j, x)] + z)
        case let .Text(s):
            let k1 = k + Int(s.characters.count)
            return Doc.Text(s, be(w, k1, z))
        case .Line: return Doc.Line(i, be(w, i, z))
        case let .Union(x, y): return better(w, k, be(w, k, [(i,x)] + z), be(w, k, [(i,y)] + z)) 
        
        }
            
    }
}

func best(w: Int, _ k: Int, _ x: DOC) -> Doc {
    return be(w, k, [(0,x)])
}

func group(doc: DOC) -> DOC {
     return flatten(doc) <§> doc
}

func pretty(w: Int, x: DOC) -> String {
    return best(w, 0, x).layout()
}

infix operator <+> { associativity left }
func <+> (x: DOC, y: DOC) -> DOC {
    return x <§> DOC.text(" ") <§> y
}
infix operator </> { associativity left }
func </> (x: DOC, y: DOC) -> DOC {
    return x <§> DOC.line <§> y
}

func folddoc(f: (DOC, DOC) -> DOC)(_ list: [DOC]) -> DOC {
    switch list.match {
        case .Nil: return .Nil
        case let .Cons(x, xs): 
            switch xs.match {
            case .Nil: return x
            default: return f(x, folddoc(f)(xs))
        }
    }
}

let spread = folddoc( <+> )
let stack  = folddoc( </> )

infix operator <+/> { associativity left }
func <+/> (x: DOC, y: DOC) -> DOC {
    return x <§> (DOC.text(" ") <|> DOC.line) <§> y
}
let words : String -> [DOC] = 
    { $0.componentsSeparatedByString(" ").map(DOC.text) }

//let fillwords = words >>> folddoc( <+/> )

func fill(ds: [DOC]) -> DOC {
    switch ds.match {
        case .Nil: return .Nil
        case let .Cons(x, xs): switch xs.match {
            case .Nil: return x
            case let .Cons(y, zs): 
                return  flatten(x) <+> fill([flatten(y)] + zs )
                        <|> 
                        (x </> fill([y] + zs))
        }
    }
}

func bracket(l: String, x: DOC, r: String) -> DOC {
    return group(DOC.text(l) <§> 
            DOC.nest(2)(DOC.line <§> x) <§> 
            DOC.line <§> DOC.text(r))
}


print("Finished :)")
//: [Next](@next)
