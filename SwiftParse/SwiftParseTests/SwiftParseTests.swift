//
//  SwiftParseTests.swift
//  SwiftParseTests
//
//  Created by Daniel Asher on 08/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import XCTest
@testable import SwiftParse

import SwiftCheck
import Quick
import Nimble

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
postfix operator * {} 
private postfix func * (g: Gen<String>) -> Gen<String> {
    return g.proliferate().fmap { $0.joinWithSeparator("") }
}
private postfix func * (g: Gen<Character>) -> Gen<String> {
    return g.proliferate().fmap(String.init)
}
postfix operator + {} 
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
    return rhs.ap( glue2 <^> lhs )
}
//infix operator ++ { associativity left }
//private func ++ <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T, U)> {
//    return tuple2 <^> lhs <*> rhs
//}

private func + <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T,U)> {
    return lhs.bind { t in rhs.bind { u in return Gen.pure((t,u)) } }
}
private func + <T,U,V>(lhs: Gen<(T, U)>, rhs: Gen<V>) -> Gen<(T,U,V)> {
    return lhs.bind { (t, u) in rhs.bind { v in return Gen.pure((t,u,v)) } }
}
private func + <T,U,V,W>(lhs: Gen<(T,U,V)>, rhs: Gen<W>) -> Gen<(T,U,V,W)> {
    return lhs.bind { (t,u,v) in rhs.bind { w in return Gen.pure((t,u,v,w)) } }
}

class SwiftParseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAll() {
        
        property("IDs are correctly parsed") <- forAll { (arbId: ArbitraryID) in
            return parse(P.ID, input: arbId.getID).0 == .Some(arbId.getID)
        }       
        
        let sep : Gen<String> = Gen<Character>
            .fromElementsOf([";", ",", " "])
            .fmap { (c: Character) in String(c) }

        let idStmtsGen = (A.ID + %"=" + A.ID + sep)
            .fmap { TupleOf4($0) }.proliferate()
            .fmap { ArrayOf($0) }
        
        property("a_list : ID '=' ID [ (';' | ',') ] [ a_list ]") 
            <- forAll(idStmtsGen) { (idStmts: ArrayOf<TupleOf4<String, String, String, String>>) in
            
            let attrList = idStmts.getArray
            let attrStr = attrList.reduce("") { str, id_stmt in
                let (lhs, eq, rhs, s) = id_stmt.getTuple
                return str + lhs + eq + rhs + s
            }
            
            let (result, _) = parse(P.attr_list, input: attrStr)
            
            switch(result) {
                case let .Some(parsedAttrList):
                    let isEqual = zip(attrList, parsedAttrList).reduce(true) { (acc, zipped) in
                        let (id_stmt, attr) = zipped
                        let (lhs, _, rhs, _) = id_stmt.getTuple
                        return acc && lhs == attr.name && rhs == attr.value
                    }
                    return isEqual
                
                case .None: 
                    return false
            }             
        }
        
//        property("a_list : ID '=' ID [ (';' | ',') ] [ a_list ]") <- forAll { (attrList: ArbitraryAttributeList) in
//        
//            let (result, _) = parse(P.attr_list, input: attrList.getAttributesString)
//            switch(result) {
//                case let .Some(attrs):
//                    let isEqual = zip(attrList.idPairs, attrs).reduce(true) { (acc, ids) in
//                        let ((idLhs, idRhs), attr) = ids
//                        return acc && idLhs == attr.name && idRhs == attr.value
//                    }
//                    return isEqual
//                case .None: return false
//            }   
//        }
    }
}
