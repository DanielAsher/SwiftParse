//: [Previous](@previous)

import Foundation
import Cocoa

let url:NSURL = NSURL(string:"www.google.com")!
let request:NSURLRequest = NSURLRequest(URL:url)
let queue:NSOperationQueue = NSOperationQueue()

func asynchronousWork(completion: (getResult: () throws -> NSDictionary) -> Void) -> Void {
    NSURLConnection.sendAsynchronousRequest(request, queue: queue) { 
        (response, data, error) -> Void in
        guard let data = data else { return }
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) 
                as! NSDictionary
            completion(getResult: {return result})
        } catch let error {
            completion(getResult: {throw error})
        }
    }
}

// Call-site
asynchronousWork { getResult in
    do {
        let result = try getResult()
    } catch let error {
        print(error)
    }
}


//: [Next](@next)
