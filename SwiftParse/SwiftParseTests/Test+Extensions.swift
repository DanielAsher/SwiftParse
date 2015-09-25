//
//  Test+Extensions.swift
//  SwiftParse
//
//  Created by Daniel Asher on 10/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation
import SwiftCheck
/// Modifies a Generator such that it produces arrays with a length determined by the receiver's
/// size parameter.
extension Gen {
    func proliferate(min min: Int, max: Int) -> Gen<[A]> {
        return Gen<[A]>.sized({ n in
            return Gen.choose((min, max)) >>- self.proliferateSized
        })
    }
}

func tuple2<T, U>(s1: T) (s2: U) -> (T, U) {
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
/// Copied (!) from swiftz `Curry.swift`
/// Converts an uncurried function to a curried function.
///
/// A curried function is a function that always returns another function or a value when applied
/// as opposed to an uncurried function which may take tuples.
public func curry<A, B, C>(f : (A, B) -> C) -> A -> B -> C {
    return { a in { b in f(a, b) } }
}

public func curry<A, B, C, D>(f : (A, B, C) -> D) -> A -> B -> C -> D {
    return { a in { b in { c in f(a, b, c) } } }
}

public func curry<A, B, C, D, E>(f : (A, B, C, D) -> E) -> A -> B -> C -> D -> E {
    return { a in { b in { c in { d in f(a, b, c, d) } } } }
}

public func curry<A, B, C, D, E, F>(f : (A, B, C, D, E) -> F) -> A -> B -> C -> D -> E -> F {
    return { a in { b in { c in { d in { e in f(a, b, c, d, e) } } } } }
}

public func curry<A, B, C, D, E, F, G>(f : (A, B, C, D, E, F) -> G) -> A -> B -> C -> D -> E -> F -> G {
    return { a in { b in { c in { d in { e in { ff in f(a, b, c, d, e, ff) } } } } } }
}

public func curry<A, B, C, D, E, F, G, H>(f : (A, B, C, D, E, F, G) -> H) -> A -> B -> C -> D -> E -> F -> G -> H {
    return { a in { b in { c in { d in { e in { ff in { g in f(a, b, c, d, e, ff, g) } } } } } } }
}



