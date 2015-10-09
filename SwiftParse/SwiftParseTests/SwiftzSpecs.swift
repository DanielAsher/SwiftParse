//
//  SwiftzSpecs.swift
//  SwiftParse
//
//  Created by Daniel Asher on 04/10/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation
import Swiftz

//struct Fib2<T: Monad, U: Monad where T.A == Int, T.B == Int, U.A == Int, U.B == Int, T.FB == U>  {
//    static func fib(n : T.A) -> U { //return 
//        //        fix { fib in 
//        switch n { 
//        case 0: return U.pure(0)
//        case 1: return U.pure(1)
//        case let n:
//            let _ = fib(n-2).fmap { $0 } //{ (a:T.A) in a }
//            //                    let x = fib(n-2).bind { (a: Int) in return .pure(a) }
//            return fib(n-2)//.bind { a in fib(n-1).bind { b in T.pure(a + b) } }
//        }
//        //        }
//    }
//}

struct Fib<T: Monad, U: Monad where T.A == Int, T.B == T.A, U.A == T.A, U.B == T.A, T.FB == U>  {
    static func fib(n : T.A) -> U { //return 
        //        fix { fib in 
        switch n { 
        case 0: return U.pure(0)
        case 1: return U.pure(1)
        case let n:
            let _ = { (a:Int) in { (b:Int) in a + b } }
            
            let f2 : Int -> Int = { a in a-2 }
            let _ =  fib(n-2).fmap(f2) // <*> fib(n-1)
//            let p = fib(n-2).fmap { $0 } //{ (a:T.A) in a }
            let _ = fib(n-2) //{ (a: Int) in return U.pure(a) }
            return fib(n-2)//.bind { a in fib(n-1).bind { b in T.pure(a + b) } }
        }
        //        }
    }
}

struct Fib3<T: Monad where T.A == Int, T.B == Int, T.FB == T> : Functor, Pointed {
    typealias A = Int
    typealias B = Int
    typealias FB = T
    static func pure(_: Fib3.A) -> Fib3 {
        return Fib3()
    }
    func fmap(f: A -> B) -> FB {
        let ret = fmap(f)
        return ret
    }
    
    func fib(n: A) -> FB {
        switch n {
        case 0: return T.pure(0)
        case 1: return T.pure(1)
        case let n: 
        
        return self.fib(n-2).bind { a in 
            return self.fib(n-1).bind { b in 
                T.pure(a + b) } 
                }
        }
    }
}

func mFib<T: Monad where T.A == Int, T.B == Int, T.FB == T>(n: Int, type:T) -> T {
    
    switch n {
    case 0: return T.pure(0)
    // ERROR: EXC_BAD_ACCESS code 1
    case 1: return T.pure(1)
    case let n:
        let a = mFib(n-2, type: type).bind
        return mFib(n-2, type: type)
        //                    .bind { a in return mFib(n-1, type: type)
        //                    .bind { b in T.pure(a + b) }
        //                    } 
        
    }
}



import Nimble
import Quick
//import func Swiftx.fix
@testable import SwiftParse
//@testable import func SwiftParse.parse
//@testable import struct SwiftParse.P


class SwiftzSpecs : QuickSpec {

    override func spec() {
        describe("more monads") {
            it("doesn't crash compiler") {
                // ERROR: EXC_BAD_ACCESS code 1
//                let a = mFib(1, type: [])
//                expect(a).notTo(beNil())
            }
        }
    }

}

