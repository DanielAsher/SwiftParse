//
//  ArbitraryTypes.swift
//  SwiftParse
//
//  Created by Daniel Asher on 10/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import SwiftCheck

struct ArbitraryID : Arbitrary 
{
    static let lowerCase : Gen<Character> = Gen<Character>.fromElementsIn("a"..."z")
    static let upperCase : Gen<Character> = Gen<Character>.fromElementsIn("A"..."Z")
    static let numeric   : Gen<Character> = Gen<Character>.fromElementsIn("0"..."9")
    static let id     : Gen<String>    = Gen<Character>
        .oneOf([upperCase, lowerCase, numeric, Gen.pure("_")])
        .proliferateNonEmpty().fmap(String.init)    
    
    static var arbitrary : Gen<ArbitraryID> { return id.fmap(ArbitraryID.init) }
    
    let getID : String
    
    init(id : String) { self.getID = id }
}

struct ArbitraryWhiteSpace : Arbitrary 
{
    static let whitespace     : Gen<String>    = Gen<Character>
        .fromElementsOf([" ", "\t", "\n"])
        .proliferateNonEmpty()
        .fmap { String($0) }   
  
    static var arbitrary : Gen<ArbitraryWhiteSpace> { return whitespace.fmap(ArbitraryWhiteSpace.init) }
    
    let getWhitespace : String
    
    init(whitespace: String) { self.getWhitespace = whitespace }
}

struct ArbitrarySeparator : Arbitrary
{
    static let separator : Gen<String> = Gen<Character>
        .fromElementsOf([";", ",", " "])
        .fmap { (c: Character) in String(c) }

        
    static var arbitrary : Gen<ArbitrarySeparator> { return separator.fmap(ArbitrarySeparator.init) }
    
    let getSeparator : String
    
    init(separator : String) { self.getSeparator = separator }
}

struct ArbitraryAttributeList : Arbitrary 
{  
    
    static let lowerCase : Gen<Character> = Gen<Character>.fromElementsIn("a"..."z")
    static let upperCase : Gen<Character> = Gen<Character>.fromElementsIn("A"..."Z")
    static let numeric   : Gen<Character> = Gen<Character>.fromElementsIn("0"..."9")
    static let id     : Gen<String>    = Gen<Character>
        .oneOf([upperCase, lowerCase, numeric, Gen.pure("_")])
        .proliferateNonEmpty().fmap(String.init)    
    
    static let whitespace     : Gen<String>    = Gen<Character>
        .fromElementsOf([" ", "\t", "\n"])
        .proliferateNonEmpty()
        .fmap { String($0) }   

    
//    static func toString(lhsId: String) (ws1: String)(eq: String)(ws2: String)(rhsId: String) -> String {
//        return lhsId + ws1 + eq + ws2 + rhsId
//    }
    
    static func glue(lhsId: String) (ws1: String) -> String {
        return lhsId + ws1 //+ eq + ws2 + rhsId
    }
    
    static let a = 
        ArbitraryAttributeList.glue <^> ArbitraryID.id <*> ArbitraryWhiteSpace.whitespace
        
        
    static let attributeList : Gen<String> = ArbitraryID.id
    
    static var arbitrary : Gen<ArbitraryAttributeList> { return attributeList.fmap(ArbitraryAttributeList.init) }
    
    let getAttributes : String
    
    init(attributes : String) { self.getAttributes = attributes }
}