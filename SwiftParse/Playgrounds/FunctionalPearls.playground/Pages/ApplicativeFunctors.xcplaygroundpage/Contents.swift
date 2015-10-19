/*:
// http://strictlypositive.org/Idiom.pdf

F U N C T I O N A L P E A R L
Idioms: applicative programming with effects
CONOR MCBRIDE
ROSS PATERSON
*/

import Darwin
import Swiftz

let a = abs(-1)
let fs : [Double -> Double] = [sin, cos]
let xs = [0.0]
let rs = fs.map { f in 
    f(1.0) }
let ys : [Double] = xs.bind { x in 
    let y = 0.5
    return [x] 
    }
    //.bind { x in [x] }
//    .flatMap { $0 }  



var str = "Hello, playground"
