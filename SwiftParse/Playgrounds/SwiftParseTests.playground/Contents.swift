//: Playground - noun: a place where people can play

import Cocoa
import SwiftParse

let p = Dot.id_equality
let (r, m) = parse(Dot.attr_list, input: "a=1", traceToConsole: true)

r
m

var str = "Hello, playground"
