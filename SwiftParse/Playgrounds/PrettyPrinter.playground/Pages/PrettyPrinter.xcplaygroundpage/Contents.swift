//: [Previous](@previous)
//: http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf

import Swiftz


extension String : DocType {
    public static var zero : String { return "" }
    public static func text(str: String) -> String { return str}
    public static var line : String { return "\n" }
    public static func nest(n: Int) -> String -> String {
        return { doc in doc.layout().stringByReplacingOccurrencesOfString("\n", withString: "\n" + String(count: n, repeatedValue: Character(" ")) )}
    }
    public func layout() -> String {
        return self
    }
    
}

public func <§> (lhs: String, rhs: String) -> String {
    return lhs.layout() + rhs.layout()
}

enum Tree { case Node(String, [Tree]) }

extension Tree {
    
    func showTree() -> String {
        switch self {
            case let .Node(str, ts): 
                let len = str.characters.count
                let doc = String.text(str) <§> 
                          String.nest(len)(Tree.showBracket(ts))
                return doc.layout()
        }
    }
    
    static func showBracket(trees: [Tree]) -> String {
        switch trees.match {
            case .Nil:  return String.zero
            case .Cons: 
                return String.text("[") <§> 
                       String.nest(1)(Tree.showTrees(trees)) <§> 
                       String.text("]")
        }
    }
    static func showTrees(trees: [Tree]) -> String {
        switch trees.match {
           case .Nil: return "" 
           case let .Cons(t, ts): switch ts.match {
                case .Nil: return t.showTree()
                case .Cons(_, _): 
                    return t.showTree() <§> String.text(",") <§> String.line <§> Tree.showTrees(ts)
           }
        }        
    }
    
    func showTree2() -> String {
        switch self {
        case let .Node(str, trees): 
            let DocType = String.text(str) <§> String.nest(0)(Tree.showBracket2(trees))
            return DocType.layout()
        }
    }
    
    static func showBracket2(trees: [Tree]) -> String {
        switch trees.match {
        case .Nil:  return String.zero
        case .Cons: 
            return  String.text("[") <§> 
                    String.nest(2)(String.line <§> Tree.showTrees2(trees)) <§> 
                    String.line <§>
                    String.text("]")
        }
    }
    static func showTrees2(trees: [Tree]) -> String {
        switch trees.match {
        case .Nil: return "" 
        case let .Cons(t, ts): switch ts.match {
        case .Nil: return t.showTree2()
        case .Cons(_, _): 
            return  t.showTree2() <§> 
                String.text(",") <§> 
                String.line <§> 
                Tree.showTrees2(ts)
            }
        }        
    }

}

let tree1 = 
    Tree.Node("aaa", 
        [Tree.Node("bbbbb", 
            [Tree.Node("ccc", []), Tree.Node("dd", [])])
        ,Tree.Node("eee", [])
        ,Tree.Node("ffff", [Tree.Node("gg", []), Tree.Node("hhh", []), Tree.Node("ii", [])]) 
        
        ])
        
print(tree1, "\n")
print(tree1.showTree(), "\n")
print(tree1.showTree2(), "\n")

print("Finished :)")

//: [Next](@next)
