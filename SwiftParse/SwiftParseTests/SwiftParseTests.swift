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

struct ArbitraryID : Arbitrary 
{
    static let lowerCase : Gen<Character> = Gen<Character>.fromElementsIn("a"..."z")
    static let upperCase : Gen<Character> = Gen<Character>.fromElementsIn("A"..."Z")
    static let numeric   : Gen<Character> = Gen<Character>.fromElementsIn("0"..."9")
    static let idGen     : Gen<String>    = Gen<Character>
        .oneOf([upperCase, lowerCase, numeric, Gen.pure("_")])
        .proliferateNonEmpty().fmap(String.init)    

    static var arbitrary : Gen<ArbitraryID> { return idGen.fmap(ArbitraryID.init) }
    
    let getID : String

    init(id : String) { self.getID = id }
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
            return parse(id, input: arbId.getID).0 == Optional.Some(arbId.getID)
        }        

    }
}
