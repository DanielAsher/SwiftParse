//
//  SwiftParseSpecs.swift
//  SwiftParse
//
//  Created by Daniel Asher on 21/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import Nimble
import Quick
@testable import SwiftParse
//@testable import func SwiftParse.parse
//@testable import struct SwiftParse.P



class SwiftParseSpecs : QuickSpec {
    
    override func spec() {
        describe("Dot parser quoted string behaviour") {
            it("handles multiple consecutive backslash and quotation marks") {
                let quotedId = "\"\\\\\""
                let (result, message) = parse(Dot.quotedId, input: quotedId)
                print(result, message)

                expect(result).to(equal(quotedId))
            }
            
            it("handles simple equality") {
                let (name, eq, value, sep) = (".0", "=", "_", " ")
                let (result, message) = parse(Dot.attr_list, input: "[" + name + eq + value + sep + "]", traceToConsole: true)
                print(result, message)
                expect(result?.first!.name).to(equal(name))
                expect(result?.first!.value).to(equal(value))
            }
            fit("generates ids") {
                let lower       = %%("a"..."z")
                let upper       = %%("A"..."Z")
                let digit       = %%("0"..."9")
                let simpleId    = (lower | upper | char("_")) & (lower | upper | digit | char("_"))*^
                let number      = %%"." & digit+^ | (digit+^ & (%%"." & digit*^)|?)
                let decimal     = (%%"-")|? & number
                
                var notQuote    = notg("\"")
                let quotedChar  = %%"\\\"" | %%"\\\\" | notQuote.weight(100)
                let quotedId    = %%"\"" & quotedChar+^ & %%"\""
                let ID          = simpleId | decimal | quotedId
                let sep         = %%";" | %%"," | %%" "
                
                let id_equality = ID ++ %%"=" +++ ID +++ sep|?
                let attr_list   = %%"[" ++ id_equality+ ++ %%"]"
                
                print(attr_list.gen.generate)
                expect(attr_list.gen.generate).toNot(beNil())
            }
        }
    }
}