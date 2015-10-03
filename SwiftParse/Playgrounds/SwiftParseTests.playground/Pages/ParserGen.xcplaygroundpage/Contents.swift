//: Playground - noun: a place where people can play
import Cocoa
import SwiftParse
import func Swiftx.fixt

let lower       = %%("a"..."z")
let upper       = %%("A"..."Z")
let digit       = %%("0"..."9")

let simpleId = (char("_") | upper | lower) & (char("_") | upper | digit | lower)+^
let number   = %%"." & digit+^ | (digit+^ & (%%"." & digit*^)|?)
let decimal  = (%%"-")|? & number

var notQuote    = notg("\"")
let quotedChar  = %%"\\\"" | %%"\\\\" | notQuote.weight(100)
let quotedId    = %%"\"" & quotedChar+^ & %%"\""
let ID          = simpleId | decimal | quotedId
let sep         = %%";" | %%"," | %%" "

let id_equality = ID ++ %%"=" ++^ ID ++^ sep|?
let attr_list   = %%"[" ++ id_equality+ ++^ %%"]"
let node_id     = ID
let edgeop      = %%"->" | %%"--"
let attr_target = %%"graph" | %%"node" | %%"edge"
let attr_stmt   = attr_target ++ attr_list
let node_stmt   = node_id ++ attr_list

node_stmt.gen.generate

func fixo<A>(f : A -> A ) -> A {
    return f(fixo(f))
}


let stmt_list1 :  Parser<[Term]> = fixo { stmt_list1 in
    let subgraph_id =  %%"subgraph" ++ ID|? 
//    let subgraph = subgraph_id ++ %%"{" ++ stmt_list1 ++ %%"}"
    let i = id_equality.fmap { Term.IdEquality(Attribute(name: $0.0, value: $0.2)) }
//    let a = attr_stmt.fmap { Term.AttrStmt(target: $0.0,)
//    let stmt = id_equality | attr_stmt
    return i* 
}

stmt_list1.gen.generate

let stmt_list : 𝐏<String, (String, String?)>.𝒇 = fixt { stmt_list in
    let subgraph_id =  %"subgraph" ++ Dot.ID|? 
    let subgraph = subgraph_id ++ %"{" ++ stmt_list ++ %"}" 
    return stmt_list
}



let p = Dot.id_equality
let (r, m) = parse(Dot.attr_list, input: "[a=1]", traceToConsole: true)

r
m



