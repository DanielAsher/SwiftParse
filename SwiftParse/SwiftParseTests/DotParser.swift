//
//  DotParser.swift
//  SwiftParse
//
//  Created by Daniel Asher on 09/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import SwiftParse
import Swiftx

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

struct P {

    static let whitespace  = %" " | %"\t" | %"\n"
    static let spaces      = ignore(whitespace*)
    //: Our `token` defines whitespace handling.
    static func token(parser: 𝐏<String, String>.𝒇 ) -> 𝐏<String, String>.𝒇 {
        return parser ++ spaces 
    }
    //: Literal Characters and Strings
    static let equal        = £"="     
    static let leftBracket  = £"["      
    static let rightBracket = £"]"     
    static let leftBrace    = £"{"     
    static let rightBrace   = £"}"     
    static let arrow        = £"->"    
    static let link         = £"--"    
    static let semicolon    = £";"     
    static let comma        = £","     
    static let quote        = £"\""    

    static let separator   = (%";" | %",") |> P.token
    static let sep         = ≠separator|?
    static let lower       = %("a"..."z")
    static let upper       = %("A"..."Z")
    static let digit       = %("0"..."9")

    static let id = (lower | upper | digit | %"_")+
        |> map { $0.joinWithSeparator("") }
        |> P.token
        
    static let id_equality = id ++ ≠equal ++ ≠quote|? ++ id ++ ≠quote|?
        |> map { Attribute(name: $0, value: $1) }
    
    static let attr_list = id_equality+

}
