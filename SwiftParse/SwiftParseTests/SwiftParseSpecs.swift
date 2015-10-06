//
//  SwiftParseSpecs.swift
//  SwiftParse
//
//  Created by Daniel Asher on 21/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import Nimble
import Quick
//import func Swiftx.fix
@testable import SwiftParse
//@testable import func SwiftParse.parse
//@testable import struct SwiftParse.P


class SwiftParseSpecs : QuickSpec {
    
    static func fix<A, B>(f : (A -> B) -> A -> B) -> A -> B {
        return { x in
            let fixed = fix(f)
            return f(fixed)(x) 
        }
    }
    
    static let fib : Int -> Int = SwiftParseSpecs.fix { fib in
        return { x in 
            switch x { 
            case 0: return 0
            case 1: return 1
            case let n: return fib(n-2) + fib(n-1)
            }
        }
    }
    
    override func spec() {
        describe("fixed-point combinator") {
            fit("does not infinitely recurse") {
                expect(SwiftParseSpecs.fib(10)).to(equal(55))
            }            
        }
        
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
            it("generates ids") {
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
                
                let id_equality = ID ++ %%"=" ++^ ID ++^ sep|?
                let attr_list   = %%"[" ++ id_equality+ ++ %%"]"
                
                print(attr_list.gen.generate)
                expect(attr_list.gen.generate).toNot(beNil())
            }
        }
    }
}