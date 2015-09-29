//
//  SwiftParse+Ext.swift
//  SwiftParse
//
//  Created by Daniel Asher on 28/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//

import Foundation
import SwiftCheck
// Modifies a Generator such that it produces arrays with a length determined by the receiver's size parameter.
extension Gen {
    func proliferate(min min: Int, max: Int) -> Gen<[A]> {
        return Gen<[A]>.sized({ n in
            return Gen.choose((min, max)) >>- self.proliferateSized
        })
    }
    func proliferate(interval: ClosedInterval<Int>) -> Gen<[A]> {
        return Gen<[A]>.sized({ n in
            return Gen.choose((interval.start, interval.end)) >>- self.proliferateSized
        })
    }
}