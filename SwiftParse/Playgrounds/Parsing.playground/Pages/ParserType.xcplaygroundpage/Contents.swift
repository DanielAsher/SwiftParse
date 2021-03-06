//: [Previous](@previous)

import Foundation

protocol ParserType {
    typealias Input : CollectionType
    typealias Tree
    typealias Function = (Input, Input.Index) throws -> (Tree, Input.Index)
    typealias Error : ErrorType
} 

enum ParserError : ErrorType {
    case Error
}

enum Parser<C: CollectionType, T> : ParserType {
    typealias Input = C
    typealias Tree = T
    typealias Error = ParserError
}
//: [Next](@next)
