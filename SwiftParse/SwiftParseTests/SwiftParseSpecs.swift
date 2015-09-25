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
                let (result, message) = parse(P.quotedId, input: quotedId, traceToConsole: true)
                print(result, message)

                expect(result).to(equal(quotedId))
            }
        }
    }
}