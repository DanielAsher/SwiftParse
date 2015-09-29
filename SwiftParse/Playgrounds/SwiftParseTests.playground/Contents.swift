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

let id_equality = ID ++ %%"=" ++ ID ++^ sep|?
let attr_list   = %%"[" ++ id_equality+ ++^ %%"]"
let node_id     = ID
let edgeop      = %%"->" | %%"--"
let attr_target = %%"graph" | %%"node" | %%"edge"
let attr_stmt   = attr_target ++ attr_list
let node_stmt   = node_id ++ attr_list

node_stmt.gen.generate


let stmt_list : Int throws -> Int = fixt { stmt_list in
    return stmt_list
}



let p = Dot.id_equality
let (r, m) = parse(Dot.attr_list, input: "[a=1]", traceToConsole: true)

r
m



