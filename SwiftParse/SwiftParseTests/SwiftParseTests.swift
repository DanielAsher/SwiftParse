//
//  SwiftParseTests.swift
//  SwiftParseTests
//
//  Created by Daniel Asher on 08/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import XCTest
@testable import func SwiftParse.parse

import SwiftCheck
import Quick
import Nimble

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
        
        property("Can invoke forAllNoShrink with an argument list of type (Gen<[String]>, ([String]) -> Bool") 
        <- forAllNoShrink(Gen.pure("0").proliferate()) { (zs: [String]) in
            return true
        }
        
        let pairGen  = Gen<(String, String)>.zip(Gen.pure("0"), Gen.pure("1")).proliferate()
        
        property("`0` and `1` are distinct") <- forAllNoShrink(pairGen) { (pairs: Array<(String, String)>) in
            let areDistinct = pairs.reduce(true) { (acc, t) in
                let (lhs, rhs) = t
                return acc && lhs != rhs
            }
            return areDistinct
        }
        
        let sep : Gen<String> = Gen<Character>
            .fromElementsOf([";", ",", " "])
            .fmap { (c: Character) in String(c) }

        let idStmtsGen = (A.ID + %"=" + A.ID + sep).proliferateNonEmpty()
        
//        property("test repeated quotation"
        
        property("a_list : ID '=' ID [ (';' | ',') ] [ a_list ]") 
            <- forAllNoShrink(idStmtsGen) { (idStmts: Array<(String, String, String, String)>) in
            
            let attrStr = idStmts.reduce("") { str, id_stmt in
                let (lhs, eq, rhs, s) = id_stmt
                return str + lhs + eq + rhs + s
            }
            
            let (result, _) = parse(P.attr_list, input: attrStr)
            
            switch(result) {
                case let .Some(parsedAttrList):
                    let allEqual = zip(idStmts, parsedAttrList).reduce(true) {
                        switch ($0, $1) {
                        case (let allEqual, let ((lhs, _, rhs, _), parsedAttr) ):
                            let isEqualLhs = lhs == parsedAttr.name
                            if isEqualLhs == false {
                                print(lhs, parsedAttr.name)
                            } 
                            let isEqualRhs = rhs == parsedAttr.value
                            if isEqualRhs == false {
                                print(rhs, parsedAttr.value)
                            } 
                            return allEqual && isEqualLhs && isEqualRhs
                        }
                    }
                    return allEqual
                
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

