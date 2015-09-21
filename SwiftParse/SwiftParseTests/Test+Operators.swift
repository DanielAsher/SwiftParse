//
//  Test+Operators.swift
//  SwiftParse
//
//  Created by Daniel Asher on 21/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation
import SwiftCheck


prefix operator % {}
prefix func % (c: Character) -> Gen<String> {
    return Gen.pure(String(c))
}
prefix func % (c: Gen<Character>) -> Gen<String> {
    return c.fmap { String($0) }
}

postfix operator |? { }
postfix func |? (s: Gen<String>) -> Gen<String> {
    return Gen<String>.oneOf([s, Gen.pure("")])
}
postfix operator * {} 
postfix func * (g: Gen<String>) -> Gen<String> {
    return g.proliferate().fmap { $0.joinWithSeparator("") }
}
postfix func * (g: Gen<Character>) -> Gen<String> {
    return g.proliferate().fmap(String.init)
}
postfix operator + {} 
postfix func + (g: Gen<String>) -> Gen<String> {
    return g.proliferateNonEmpty().fmap { $0.joinWithSeparator("") }
}
postfix func + (g: Gen<Character>) -> Gen<String> {
    return g.proliferateNonEmpty().fmap(String.init)
}

infix operator | {associativity left}
func | <T> (lhs: Gen<T>, rhs: Gen<T>) -> Gen<T> {
    return Gen<T>.oneOf([lhs, rhs])
}
infix operator & { associativity left }
func & (lhs: Gen<String>, rhs: Gen<String>) -> Gen<String> {
    return rhs.ap( glue2 <^> lhs )
}
//infix operator ++ { associativity left }
//private func ++ <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T, U)> {
//    return tuple2 <^> lhs <*> rhs
//}

private func + <T,U>(lhs: Gen<T>, rhs: Gen<U>) -> Gen<(T,U)> {
    return lhs.bind { t in rhs.bind { u in return Gen.pure((t,u)) } }
}
private func + <T,U,V>(lhs: Gen<(T, U)>, rhs: Gen<V>) -> Gen<(T,U,V)> {
    return lhs.bind { (t, u) in rhs.bind { v in return Gen.pure((t,u,v)) } }
}
private func + <T,U,V,W>(lhs: Gen<(T,U,V)>, rhs: Gen<W>) -> Gen<(T,U,V,W)> {
    return lhs.bind { (t,u,v) in rhs.bind { w in return Gen.pure((t,u,v,w)) } }
}


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

