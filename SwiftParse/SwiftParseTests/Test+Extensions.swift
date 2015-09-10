//
//  Test+Extensions.swift
//  SwiftParse
//
//  Created by Daniel Asher on 10/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation

func glue2(s1: String) (s2: String) -> String {
    return s1 + s2 
}

func glue3(s1: String) (s2: String) (s3: String) -> String {
    return s1 + s2 + s3
}

func glue4(s1: String) (s2: String) (s3: String) (s4: String) -> String {
    return s1 + s2 + s3 + s4
}

func glue5(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) -> String {
    return s1 + s2 + s3 + s4 + s5
}

func glue6(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) (s6: String) -> String {
    return s1 + s2 + s3 + s4 + s5 + s6
}

func glue7(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) (s6: String) (s7: String) -> String {
    return s1 + s2 + s3 + s4 + s5 + s6 + s7
}

func tuple2(s1: String) (s2: String) -> (String, String) {
    return (s1, s2) 
}

func tuple3(s1: String) (s2: String) (s3: String) -> (String, String, String) {
    return (s1, s2, s3)
}

func tuple4(s1: String) (s2: String) (s3: String) (s4: String) -> (String, String, String, String) {
    return (s1, s2, s3, s4)
}

func tuple5(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) -> (String, String, String, String, String) {
    return (s1, s2, s3, s4, s5)
}

func tuple6(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) (s6: String) -> (String, String, String, String, String, String) {
    return (s1, s2, s3, s4, s5, s6)
}

func tuple7(s1: String) (s2: String) (s3: String) (s4: String) (s5: String) (s6: String) (s7: String) -> (String, String, String, String, String, String, String) {
    return (s1, s2, s3, s4, s5, s6, s7)
}


