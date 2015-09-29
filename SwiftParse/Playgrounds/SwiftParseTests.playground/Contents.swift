//: Playground - noun: a place where people can play
import Cocoa
import SwiftParse

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

let id_equality = ID ++ %%"=" +++ ID +++ sep|?
let attr_list   = %%"[" ++ id_equality+ ++ %%"]"

attr_list.gen.generate





let p = Dot.id_equality
let (r, m) = parse(Dot.attr_list, input: "[a=1]", traceToConsole: true)

r
m



