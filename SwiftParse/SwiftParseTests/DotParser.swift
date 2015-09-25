//
//  DotParser.swift
//  SwiftParse
//
//  Created by Daniel Asher on 09/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import func Swiftx.|>

prefix operator ≠ {}
public prefix func ≠ <I: CollectionType, T>
    (parser: 𝐏<I, T>.𝒇) 
    -> 𝐏<I, Ignore>.𝒇 
{
    return ignore(parser)
}

prefix operator £ {}
public prefix func £ (literal: String) -> 𝐏<String, String>.𝒇 {
    return %literal |> P.token
}

public struct P {

    static let whitespace  = %" " | %"\t" | %"\n"
    //: Our `token` defines whitespace handling.
    static func token(parser: 𝐏<String, String>.𝒇 ) -> 𝐏<String, String>.𝒇 {
        return parser ++ ignore(whitespace*) 
    }
    //: Literal Characters and Strings
//    static let equal        = £"="     
//    static let leftBracket  = £"["      
//    static let rightBracket = £"]"     
//    static let leftBrace    = £"{"     
//    static let rightBrace   = £"}"     
//    static let arrow        = £"->"    
//    static let link         = £"--"    
//    static let semicolon    = £";"     
//    static let comma        = £","     
//    static let quote        = £"\""    

    static let separator   = (%";" | %",") |> P.token
    static let sep         = ≠separator|?
    static let lower       = %("a"..."z")
    static let upper       = %("A"..."Z")
    static let digit       = %("0"..."9")

    // simpleId cannot start with a digit.
    static let simpleId = (lower | upper | %"_") & (lower | upper | digit | %"_")*^

    static let number = %"." & digit+^ | (digit+^ & (%"." & digit*^)|?)
    static let decimal = (%"-")|? & number
    
    static let quotedChar   = %"\\\"" | %"\\\\" | not("\"") 
    static let quotedId     = %"\"" & quotedChar+^ & %"\""
    static let ID           = (simpleId | decimal | quotedId) |> P.token
    static let id_equality  = ID ++ £"=" ++ ID ++ sep
                |> map { Attribute(name: $0, value: $1.1) }
    
    static let attr_list = id_equality+

}






