//: [Previous](@previous)

import Cocoa
import SwiftParse

let chars = ("\u{38}")
let a = Character(UnicodeScalar(379))

SwiftxTrace = true
prefix operator £ {}
public prefix func £ (literal: String) -> 𝐏<String, String>.𝒇 {
    return %literal |> P.token
}

public struct P {
    
    static let whitespace  = %" " | %"\t" | %"\n"
    static let spaces      = ignore(whitespace*)
    //: Our `token` defines whitespace handling.
    static func token(parser: 𝐏<String, String>.𝒇 ) -> 𝐏<String, String>.𝒇 {
        return parser ++ spaces 
    }
    
    static let separator   = (%";" | %",") |> P.token
    static let lower       = %("a"..."z")
    static let upper       = %("A"..."Z")
    static let digit       = %("0"..."9")
    
    // simpleId cannot start with a digit.
    static let simpleId = (lower | upper | %"_") & (lower | upper | digit | %"_")*^
    
    static let number = %"." & digit+^ | (digit+^ & (%"." & digit*^)|?)
    static let decimal = (%"-")|? & number
    
    static let quotedChar = %"\\\"" | not("\"") 
    static let quotedId = %"\"" & quotedChar+^ & %"\""
    static let ID = (simpleId | decimal | quotedId) |> P.token
    static let id_equality = ID *> £"=" ++ ID
//        |> map { Attribute(name: $0, value: $1) }
    
    static let attr_list = id_equality+
    
}

let r1 = parse(P.ID, input: "\"í\"\t")
r1.0!.characters.count



//
//let url:NSURL = NSURL(string:"www.google.com")!
//let request:NSURLRequest = NSURLRequest(URL:url)
//let queue:NSOperationQueue = NSOperationQueue()
//
//func asynchronousWork(completion: (getResult: () throws -> NSDictionary) -> Void) -> Void {
//    NSURLConnection.sendAsynchronousRequest(request, queue: queue) { 
//        (response, data, error) -> Void in
//        guard let data = data else { return }
//        do {
//            let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) 
//                as! NSDictionary
//            completion(getResult: {return result})
//        } catch let error {
//            completion(getResult: {throw error})
//        }
//    }
//}
//
//// Call-site
//asynchronousWork { getResult in
//    do {
//        let result = try getResult()
//    } catch let error {
//        print(error)
//    }
//}


//: [Next](@next)
