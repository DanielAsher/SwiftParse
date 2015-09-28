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
            
            fit("handles simple equality") {
                let (name, eq, value, sep) = (".0", "=", "_", " ")
                let (result, message) = parse(Dot.attr_list, input: "[" + name + eq + value + sep + "]", traceToConsole: true)
                print(result, message)
                expect(result?.first!.name).to(equal(name))
                expect(result?.first!.value).to(equal(value))
            }
        }
    }
}