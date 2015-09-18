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
        
        property("a_list : ID '=' ID [ (';' | ',') ] [ a_list ]") <- forAll { (attrList: ArbitraryAttributeList) in
        
            let (result, _) = parse(P.attr_list , input: attrList.getAttributesString)
            switch(result) {
                case let .Some(attrs):
                    let isEqual = zip(attrList.idPairs, attrs).reduce(true) { (acc, ids) in
                        let ((idLhs, idRhs), attr) = ids
                        return acc && idLhs == attr.name && idRhs == attr.value
                    }
                    return isEqual
                case .None: return false
            }   
        }
    }
    
    func testMisc() {
        let setOfArrays = Set([[1,2,3,4],[6,7,8,9]])
        print(setOfArrays)
    } 
    
}
