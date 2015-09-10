//
//  ArbitraryTypes.swift
//  SwiftParse
//
//  Created by Daniel Asher on 10/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
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

struct ArbitraryID : Arbitrary 
{
    static let lowerCase : Gen<Character> = Gen<Character>.fromElementsIn("a"..."z")
    static let upperCase : Gen<Character> = Gen<Character>.fromElementsIn("A"..."Z")
    static let numeric   : Gen<Character> = Gen<Character>.fromElementsIn("0"..."9")
    static let id        : Gen<String>    = Gen<Character>
        .oneOf([upperCase, lowerCase, numeric, Gen.pure("_")])
        .proliferateNonEmpty().fmap(String.init)    
    
//    static let idToken   : Gen<String> = glue2 <^> id <*> A.ws
    
    static var arbitrary : Gen<ArbitraryID> { return id.fmap(ArbitraryID.init) }
    
    let getID : String
    
    init(id : String) { self.getID = id }
}

extension A { static let id = ArbitraryID.id }

struct ArbitrarySeparator : Arbitrary
{
    static let separator : Gen<String> = Gen<Character>
        .fromElementsOf([";", ",", " "])
        .fmap { (c: Character) in String(c) }

    static let separatorToken   : Gen<String> = glue2 <^> separator <*> A.ws

    static var arbitrary : Gen<ArbitrarySeparator> { return separatorToken.fmap(ArbitrarySeparator.init) }
    
    let getSeparator : String
    
    init(separator : String) { self.getSeparator = separator }
}

extension A { static let sep = ArbitrarySeparator.separator }

struct ArbitraryAttributeList : Arbitrary 
{  
    static let separator : Gen<String> = Gen<Character>
        .fromElementsOf([";", ",", " "])
        .fmap { (c: Character) in String(c) }
    
    static let sep   : Gen<String> = glue3 <^> A.ws <*> separator <*> A.ws
    static let equal : Gen<String> = glue3 <^> A.ws <*> Gen.pure("=") <*> A.ws
    
    static let idStatement = (tuple4 <^> A.id <*> equal <*> A.id <*> sep)//.fmap { ($0.0, $0.2) }
        
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


