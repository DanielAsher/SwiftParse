//
//  DotParser.swift
//  SwiftParse
//
//  Created by Daniel Asher on 09/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation
import SwiftParse
import Swiftx

let whitespace  = %" " | %"\t" | %"\n"
let spaces      = ignore(whitespace*)
//: Our `token` defines whitespace handling.
func token(parser: 𝐏<String, String>.𝒇 ) -> 𝐏<String, String>.𝒇 {
    return parser ++ spaces 
}
prefix operator £ {}
public prefix func £ (literal: String) -> 𝐏<String, String>.𝒇 {
    return %literal |> token
}
//: Literal Characters and Strings

let equal        = £"="     
let leftBracket  = £"["      
let rightBracket = £"]"     
let leftBrace    = £"{"     
let rightBrace   = £"}"     
let arrow        = £"->"    
let link         = £"--"    
let semicolon    = £";"     
let comma        = £","     
let quote        = £"\""    

let separator   = (%";" | %",") |> token
let sep1        = separator|? |> map { $0 ?? "" }
let sep         = separator|? |> ignore
let lower       = %("a"..."z")
let upper       = %("A"..."Z")
let digit       = %("0"..."9")

let id = (lower | upper | digit | %"_")+
    |> map { $0.joinWithSeparator("") }
    |> token



