//
//  SwiftParseTests.swift
//  SwiftParseTests
//
//  Created by Daniel Asher on 08/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import XCTest
@testable import func SwiftParse.parse
@testable import struct SwiftParse.P

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
        
        let sep : Gen<String> = Gen<Character>
            .fromElementsOf([";", ",", " "])
            .fmap { (c: Character) in String(c) }

        let idStmtsGen = (A.ID + %"=" + A.ID + sep)
            .fmap { TupleOf4($0) }.proliferate(min:2, max: 10)
            .fmap { ArrayOf($0) }
                        
        property("a_list : ID '=' ID [ (';' | ',') ] [ a_list ]") <- forAll(idStmtsGen) { 
            
            (idStmts: ArrayOf<TupleOf4<String, String, String, String>>) in
        
            let idStmtArray = idStmts.getArray
            guard idStmtArray.count > 0 else {return true}
            let attrStr = idStmtArray.reduce("") { str, id_stmt in
                let (lhs, eq, rhs, s) = id_stmt.getTuple
                return str + lhs + eq + rhs + s
            }
            
            let (result, _) = parse(P.attr_list, input: attrStr)
            
            switch(result) {
                case let .Some(parsedAttrList):
                    let allEqual = zip(idStmtArray, parsedAttrList).reduce(true) {
                        switch ($0, $1.0.getTuple, $1.1) {
                        case (let allEqual, let (nameID, _, valueID, _), let parsedAttr):                           
                            return allEqual && nameID == parsedAttr.name && valueID == parsedAttr.value
                        }
                    }
                    return allEqual
                
                case .None: 
                    return false
            }
        }
    }
}











