//
//  ArbitraryTypes.swift
//  SwiftParse
//
//  Created by Daniel Asher on 10/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import Swiftx
import SwiftCheck

// `struct A` holds extention properties of type Arbitrary to allow some syntax sugar.
struct A { }

struct ArbitraryWhiteSpace : Arbitrary 
{
    static let whitespace     : Gen<String>    = Gen<Character>
        .fromElementsOf([" ", "\t", "\n"])
        .proliferate()
        .fmap { $0.joinWithSeparator("") }   
    
    static var arbitrary : Gen<ArbitraryWhiteSpace> { return whitespace.fmap(ArbitraryWhiteSpace.init) }
    
    let getWhitespace : String
    
    init(whitespace: String) { self.getWhitespace = whitespace }
}

extension A { static let ws = ArbitraryWhiteSpace.whitespace }

prefix operator % {}
private prefix func % (c: Character) -> Gen<String> {
    return Gen.pure(String(c))
}
private prefix func % (c: Gen<Character>) -> Gen<String> {
    return c.fmap { String($0) }
}
postfix operator |? { }
private postfix func |? (s: Gen<String>) -> Gen<String> {
    return Gen<String>.oneOf([s, Gen.pure("")])
}

private postfix func * (g: Gen<String>) -> Gen<String> {
    return g.proliferate().fmap { $0.joinWithSeparator("") }
}
private postfix func * (g: Gen<Character>) -> Gen<String> {
    return g.proliferate().fmap(String.init)
}
private postfix func + (g: Gen<String>) -> Gen<String> {
    return g.proliferateNonEmpty().fmap { $0.joinWithSeparator("") }
}
private postfix func + (g: Gen<Character>) -> Gen<String> {
    return g.proliferateNonEmpty().fmap(String.init)
}

infix operator | {associativity left}
private func | <T> (lhs: Gen<T>, rhs: Gen<T>) -> Gen<T> {
    return Gen<T>.oneOf([lhs, rhs])
}
infix operator & { associativity left }
private func & (lhs: Gen<String>, rhs: Gen<String>) -> Gen<String> {
    return glue2 <^> lhs <*> rhs
}
infix operator ++ { associativity left }
private func ++ <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T, U)> {
    return tuple2 <^> lhs <*> rhs
}
private func + <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T,U)> {
    return lhs >>- { t in rhs >>- { u in return Gen.pure((t,u)) } }
}
private func + <T,U,V>(lhs: Gen<(T, U)>, rhs: Gen<V>) -> Gen<(T,U,V)> {
    return lhs >>- { (t, u) in rhs >>- { v in return Gen.pure((t,u,v)) } }
}
private func + <T,U,V,W>(lhs: Gen<(T,U,V)>, rhs: Gen<W>) -> Gen<(T,U,V,W)> {
    return lhs >>- { (t,u,v) in rhs >>- { w in return Gen.pure((t,u,v,w)) } }
}
struct ArbitraryID : Arbitrary 
{
    static let lowerCase : Gen<Character> = Gen<Character>.fromElementsIn("a"..."z")
    static let upperCase : Gen<Character> = Gen<Character>.fromElementsIn("A"..."Z")
    static let numeric   : Gen<Character> = Gen<Character>.fromElementsIn("0"..."9")
    static let underscore =  Gen.pure(Character("_"))

    static let decimal : Gen<String> = (%"-")|? & ( (%"." & numeric+) | (numeric+ & (%"." & numeric*)|?) )
    
    static let letter   = (lowerCase | upperCase | underscore)
    static let simpleID = %letter & (letter | numeric)*

    static let quotedId = 
        String.arbitrary.suchThat { $0.count >= 1 }.fmap { 
            "\"" + 
            $0.stringByReplacingOccurrencesOfString("\"", withString: "\\\"") 
            + "\"" }
    
    static let ID = (simpleID | decimal | quotedId)
    
    static var arbitrary : Gen<ArbitraryID> { return ID.fmap(ArbitraryID.init) }
    
    let getID : String
    
    init(id : String) { self.getID = id }
}

extension A { static let ID = ArbitraryID.ID }

struct ArbitraryAttributeList : Arbitrary 
{  
    static let separator : Gen<String> = Gen<Character>
        .fromElementsOf([";", ",", " "])
        .fmap { (c: Character) in String(c) }
    
    static let sep   : Gen<String> = glue3 <^> A.ws <*> separator <*> A.ws
    static let equal : Gen<String> = glue3 <^> A.ws <*> Gen.pure("=") <*> A.ws
    
    static let idStatement = tuple4 <^> A.ID <*> equal <*> A.ID <*> sep
    
    static let id_stmt = A.ID + %"=" + A.ID + separator|?
                
    static let attributeList = idStatement.proliferateNonEmpty()
    
    static var arbitrary : Gen<ArbitraryAttributeList> { return attributeList.fmap(ArbitraryAttributeList.init) }
    
    let getAttributes : [(String, String, String, String)]
    
    var idPairs : [(String, String)] {
        return getAttributes.map { ($0.0, $0.2)}
    }
    var getAttributesString : String {
        return getAttributes.map { $0.0 + $0.1 + $0.2 + $0.3 }.joinWithSeparator("")
    }
    init(attributes : [(String, String, String, String)]) { self.getAttributes = attributes }
}


