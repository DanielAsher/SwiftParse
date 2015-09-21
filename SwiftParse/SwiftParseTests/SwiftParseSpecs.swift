//
//  SwiftParseSpecs.swift
//  SwiftParse
//
//  Created by Daniel Asher on 21/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import Nimble
import Quick
@testable import func SwiftParse.parse
@testable import struct SwiftParse.P

class SwiftParseSpecs : QuickSpec {
    
    override func spec() {
        describe("Dot parser quoted string behaviour") {
            it("Þ|K£Y0Î:äC%<Ü9Qè!D¦¨rÉMÔÎ}g×avÔ/Ð9XBg>­Aqöæ³ ÕÀëR#þ\";") {
                expect(false)
            }
        }
    }
}