import Foundation

infix operator <§> { associativity right }

public protocol DocType {
    static var zero : Self { get }
    static func text(str: String) -> Self
    static var line : Self { get }
    static func nest(n:Int) -> Self -> Self
    func layout() -> String
    func <§> (lhs: Self, rhs: Self) -> Self
}

//public func <!> (lhs: DocType, rhs: DocType) -> DocType {
//    return lhs.layout() + rhs.layout()
//}

