/*: 
# Parser combinators from scratch 
## Swiftz.playground
### SwiftReferenceApp
### Created by Daniel Asher on 5/08/2015.
### Copyright (c) 2015 StoryShare. All rights reserved.
*/
/*:
## let `𝐏` be a parser monad: `𝐏 <Input,Tree>`
## let `𝒇` be the parser computation:
## `𝒇 : (Input, Input.Index) throws -> (Tree, Input.Index)`
*/
import SwiftCheck
import func Swiftx.identity
import func Swiftx.const
import func Swiftx.|>
import enum Swiftx.Either


public enum 𝐏 < Input: CollectionType, Tree> {
    public typealias 𝒇 = (Input, Input.Index) throws -> Result
    public typealias Result = (Tree, Input.Index)
}


public struct Parser<T> {
    public typealias ResultType = T
    public let fun : 𝐏<String, T>.𝒇
    public let gen : Gen<T>
    var _weight = 1
    public init(fun: 𝐏<String, T>.𝒇, gen: Gen<T>) {
        self.fun = fun
        self.gen = gen
    }
    public mutating func weight(w: Int) -> Parser<T> {
        _weight = w
        return self
    }
}


public struct ParGen<T,U> {
    let fun : 𝐏<String, T>.𝒇
    var gen : Gen<U>
}
var indentCount = 0
let indent :  () -> String = { String(count: indentCount, repeatedValue: Character("\t")) }
let padCount : () -> Int = { 50 - indentCount * 3 }

public var SwiftParseTrace = false

public func tracePrint(message: String, caller: String = __FUNCTION__, line: Int = __LINE__) {
    if SwiftParseTrace {
        let line = "\(line)".padding(6)
        let str = (line + caller + indent()).padding(padCount()) + message
        print(str)
    }
}

public func trace<I: CollectionType, T>
    (caller: String = __FUNCTION__, line: Int = __LINE__)
    (_ parser: 𝐏<I, T>.𝒇)
            -> 𝐏<I, T>.𝒇
{
    guard SwiftParseTrace == true else { return parser }
    let line = "\(line)".padding(6)
    
    return { xs, xi in
        print((line + ": \"\(xs)\" ; \(xi)".padding(40) + indent() + "🔜  " + caller))
        indentCount++
        let (ys, yi) = try parser(xs, xi) 
        indentCount--
        print((line + ": \"\(xs)\" -> \"\(ys)\"; \(xi) ->  \(yi)".padding(40) + indent() + "🔚  " + caller))
        return (ys, yi) 
    }
}

/*: 
`pure` returns a parser which always ignores its input and produces a constant value.
*/
public func pure<I: CollectionType, T>
    (value: T) -> 𝐏<I, T>.𝒇 
{
    return { _, index in (value, index) } |> trace() 
}
/*: 
## `>>-` : The fundamental operator `bind`
*/
infix operator >>- {  associativity left precedence 130 }
infix operator <*> { associativity left precedence 130 }
infix operator <* { associativity left precedence 130 }
infix operator *> { associativity left precedence 130 }
//: `++` associates to the right, linked-list style. Higher precedence than `|.`
infix operator ++ { associativity right precedence 160 }
infix operator +++ {associativity left precedence 150}
infix operator ++++ {associativity left precedence 140}
//: Map operator. Lower precedence than |.
infix operator --> { associativity left precedence 100 }


prefix operator % {}
postfix operator |? {}  //: `|?` is the optionality operator.
postfix operator *^ {}
postfix operator +^ {}




/*: 
## Bind: 
`>>-` defines `𝐏<I, *>.𝒇` as monadic
*/
public func >>- <I: CollectionType, T, U> (
    parser:     𝐏<I, T>.𝒇, 
    transform:  T -> 𝐏<I, U>.𝒇) -> 𝐏<I, U>.𝒇 
{
    return { input, index in
        let (result, newIndex) = try trace(">>- p(\"\(input)\", \(index)) ")(parser)(input, index) 
        return try trace(">>- f(\"\(result)\")(\"\(input)\", \(newIndex))") (transform(result)) (input, newIndex)
    }
}
public func >>- <T, U> (
    parser:     Parser<T>, 
    transform:  T -> Parser<U>) -> Parser<U> 
{    
    return Parser<U> (
        fun: parser.fun >>- { x in transform(x).fun },
        gen: parser.gen >>- { x in transform(x).gen }
    )
}
//public func >>- <A, B>(p : Parser<A>, transform : A -> Parser<B>) -> Parser<B> {
//    let f = p.fun >>- transform 
//    let g = p.gen >>- transform
//    return Parser<B>(fun: f, gen: g)
//}
//: `apply` returns a parser which applies `transform: T -> U` to transform the output, `T`, of `parser`.
//: notice how `transform` is _injected_ into parser's monadic context.
public func <^> <I: CollectionType, T, U> 
    (transform: T -> U, 
     parser:    𝐏<I, T>.𝒇) 
             -> 𝐏<I, U>.𝒇 
{
    return { input, index in 
        
        //let dbg1  = { (p: 𝐏<I, T>.𝒇) in trace("<^> p(\"\(input)\", \(index)) ")(p) } // Expensive call to string interpolation
        let dbg1  = { (p: 𝐏<I, T>.𝒇) in trace()(p) }
        
        let (result, newIndex) = try dbg1(parser)(input, index)
        
        //let dbg2 =  { (p: 𝐏<I, U>.𝒇) in trace("<^> pure(f(\"\(result)\"))(\"\(input)\", \(newIndex))")(p) } // Expensive call to string interpolation
        let dbg2 =  { (p: 𝐏<I, U>.𝒇) in trace()(p) }
        
        return try dbg2 (pure(transform(result))) (input, newIndex)
    }
    //return parser >>- { pure(transform($0)) }  // Elegant, but increases call stack size.
}
//: map is a curried form of ` <^> `, to be used with `|>`
public func map<I: CollectionType, T, U>
    (transform: T -> U)
    (_ parser:  𝐏<I, T>.𝒇) 
             -> 𝐏<I, U>.𝒇 
{
    return transform <^> parser |> trace() 
}
public func <^> <A, B>(transform : A -> B, p : Parser<A>) -> Parser<B> {
    let f = p.fun >>- { a in pure(transform(a)) } 
    let g = p.gen >>- { a in Gen.pure(transform(a)) }
    return Parser<B>(fun: f, gen: g)
}
extension Parser {
//    typealias A = Swift.Any
    public func fmap<A>(f : (ResultType -> A)) -> Parser<A> {
        return f <^> self
    }
}
public func <*> <I: CollectionType, T, U>(
    fp: 𝐏<I, T->U>.𝒇,
    p:  𝐏<I, T>.𝒇) 
     -> 𝐏<I, U>.𝒇 
{
    return fp >>- { $0 <^> p }
}
public func <* <I: CollectionType, T, U> 
    (lhs: 𝐏<I, T>.𝒇, 
     rhs: 𝐏<I, U>.𝒇) 
       -> 𝐏<I, U>.𝒇 
{
    return lhs >>- { x in { y in y } <^> rhs }
}

public func *> <I: CollectionType, T, U> 
    (lhs: 𝐏<I, T>.𝒇, 
     rhs: 𝐏<I, U>.𝒇) 
       -> 𝐏<I, T>.𝒇 
{
    return lhs >>- { x in { y in x } <^> rhs }
}

//: `ParserError`
public enum ParserError<Input: CollectionType> : ErrorType {
    case Error(message: String, index: Input.Index)
}

//: # Optionality
//: The type of trees to drop from the input.
public struct Ignore {
    public init() {}
}
//: `|?` parses T zero or one time to return T?
public postfix func |? <I: CollectionType, T> 
    (parser: 𝐏<I, T>.𝒇) 
          -> 𝐏<I, T?>.𝒇 
{
    return first <^> parser * (0...1)
}
public postfix func |? <T> 
    (parser: Parser<T>) -> Parser<T?> 
{
    return first <^> parser * (0...1)
}
//: `|?` parses T zero or one time to return an `Ignore`, dropping the parse tree.
public postfix func |? <I: CollectionType> 
    (parser: 𝐏<I, Ignore>.𝒇) 
          -> 𝐏<I, Ignore>.𝒇 
{
    return ignore(parser * (0...1))
}
////: Parses any single character
//public func satisfy<I: CollectionType, T>(predicate: (T) -> Bool) -> 𝐏<I, T>.𝒇 
//{
//    return { (input, index) in 
//        
//        (input, index) }
////        guard index < input.endIndex else {
////            throw ParserError<I>.Error(message: "Expecting `any` character at \(index)", index: index)
////        }
////        return (input[index..<index.advancedBy(1, limit: input.endIndex)], index.successor())
////        }
//}

//: Parses any single character
public func any(input: String, index: String.Index) throws ->  𝐏<String, String>.Result {
    guard index < input.endIndex else {
        throw ParserError<String>.Error(message: "Expecting `any` character at \(index)", index: index)
    }
    return (input[index..<index.advancedBy(1, limit: input.endIndex)], index.successor())
}

//: Parses any single character
public func not(literal: String) ->  𝐏<String, String>.𝒇 {
    return { input, index in
        guard index < input.endIndex else {
            throw ParserError<String>.Error(message: "Expecting `not` character at \(index)", index: index)
        }

        let literalRange = literal.startIndex ..< literal.endIndex
        
        let matchEnd = index.advancedBy(literalRange.count, limit: input.endIndex)
        
        if input[index ..< matchEnd].elementsEqual(literal[literalRange]) {
            tracePrint("\t\tnot \"\(literal)\" \(matchEnd)")
            throw ParserError<String>.Error(message: "did not expected \"\(literal)\" at offset:\(index)", index: index)
        } else {
            tracePrint("\t\tnot \"\(literal)\" \(matchEnd)")
            return (input[index..<index.advancedBy(1, limit: input.endIndex)], index.successor())        
        }
    }
}
public func notg(literal: String) -> Parser<String> {
    let g = Character.arbitrary
        .suchThat { literal.characters.contains($0) == false }
        .fmap { (c:Character) in String(c) }
    
    return Parser<String>(fun: not(literal), gen: g)
}
//: Parser algebras need `OR` and `AND` operators to map over their domain.
//: ## Alternation:
//: `alternate` takes two parsers, `(lhs: T)` and `(rhs: U)` and produces a tuple `(T, U)` 
public func alternate<Input: CollectionType, T, U> 
    ( leftParser:  𝐏<Input, T>.𝒇, 
    _ rightParser: 𝐏<Input, U>.𝒇)
    (input: Input, index: Input.Index) throws -> 𝐏<Input, Either<T, U>>.Result
{
    do {
        let (result, newIndex) = try trace("alt left\t:") (leftParser) (input, index) 
        return ( Either<T,U>.Left(result), newIndex ) 
    } 
    catch ParserError<Input>.Error(_, _) {
        do {
            let (result, newIndex) = try trace("alt right\t:") (rightParser) (input, index)   
            return ( Either<T,U>.Right(result), newIndex ) 
        } 
        catch ParserError<Input>.Error(let m, let i) {
            throw ParserError<Input>.Error(message: "no alternative matched: \(m)", index: i)
        }
    }
}
//: `|` parses either `(lhs: U)` or `(rhs: T)` and creates a parser that returns `Either<T, U>`
public func | <I: CollectionType, T, U> (
    lhs: 𝐏<I, T>.𝒇, 
    rhs: 𝐏<I, U>.𝒇) 
      -> 𝐏<I, Either<T, U>>.𝒇 
{
    return alternate(lhs, rhs) 
}
//: `|` parses either `(lhs: T)` or `(rhs: T)` and creates a parser that **coalesces** their `T`s
public func | <I: CollectionType, T> (
    lhs: 𝐏<I, T>.𝒇, 
    rhs: 𝐏<I, T>.𝒇) 
      -> 𝐏<I, T>.𝒇 
{
    return alternate(lhs, rhs)
        |> map { $0.either(onLeft: identity, onRight: identity) }
        |> trace("| <T,T> \t:") 
}
//: `|` parses either `(lhs: U)` or `(rhs: T)` and creates a parser that returns `Either<T, U>`
public func | <T> (
    lhs: Parser<T>, 
    rhs: Parser<T>) 
      -> Parser<T>
{
    let f = alternate(lhs.fun, rhs.fun) |> map { $0.either(onLeft: identity, onRight: identity) }
//    let g = Gen<T>.oneOf([lhs.gen, rhs.gen])
    let g = Gen<T>.frequency([(lhs._weight, lhs.gen), (rhs._weight, rhs.gen)])
    return Parser<T>( fun: f, gen: g )
}
public func | <T,U> (
    lhs: ParGen<T,U>, 
    rhs: ParGen<T,U>) 
      -> ParGen<T,U>
{
    let f = alternate(lhs.fun, rhs.fun) |> map { $0.either(onLeft: identity, onRight: identity) }
    let g = Gen<U>.oneOf([lhs.gen, rhs.gen])
    return ParGen<T,U>( fun: f, gen: g )
}
//: `first` helper function.
func first<I: CollectionType>(input: I) -> I.Generator.Element? {
    return input.first
}
//: ## Concatenation:
//: Concatenation operator. 
//: `++` parses the concatenation of `lhs` and `rhs`, pairing their parse trees in tuples of `(T, U)`
public func ++ <I: CollectionType, T, U> (
    lhs: 𝐏<I, T>.𝒇, 
    rhs: 𝐏<I, U>.𝒇) 
      -> 𝐏<I,(T, U)>.𝒇 
{
    return lhs >>- { x in { y in (x, y) } <^> rhs } 
        |> trace("++ (T,U)")
}

//: `++` parses the concatenation of `lhs` and `rhs`, dropping `rhs`’s parse tree to generate `T`
public func ++ <I: CollectionType, T> (
    lhs: 𝐏<I, T>.𝒇, 
    rhs: 𝐏<I, Ignore>.𝒇) 
    -> 𝐏<I, T>.𝒇 
{
    return lhs >>- { x in const(x) <^> rhs } 
        |> trace("++ (T, Ignore)\t:")
}
//: `++` parses the concatenation of `lhs` and `rhs`, dropping `rhs`’s parse tree to generate `T`
//infix operator +++ {associativity left}
public func ++ <T, U> (lhs: Parser<T>, rhs: Parser<U>) -> Parser<(T, U)>{
    return lhs >>- { x in { y in (x,y) } <^> rhs}
}
public func +++ <T,U,V> (lhs: Parser<(T,U)>, rhs: Parser<V>) -> Parser<(T,U,V)>{
    return lhs >>- { (t,u) in { v in (t,u,v) } <^> rhs }
}
public func +++ <T,U,V,W> (lhs: Parser<(T,U,V)>, rhs: Parser<W>) -> Parser<(T,U,V,W)>{
    return lhs >>- { (t,u,v) in { w in (t,u,v,w) } <^> rhs }
}
//: Parses the concatenation of `lhs` and `rhs`, dropping `lhs`’s parse tree generating `T`
public func ++ <I: CollectionType, T> (
    lhs: 𝐏<I, Ignore>.𝒇, 
    rhs: 𝐏<I, T>.𝒇) 
      -> 𝐏<I, T>.𝒇 
{
    return lhs >>- const(rhs) 
        |> trace("++ (Ignore, T)\t:")
}

public protocol Addable { func +(lhs: Self, rhs: Self) -> Self }
extension String : Addable {}
public protocol DefaultConstructible { init() }
extension String : DefaultConstructible {}

public func & <I: CollectionType, T where T: Addable> (
    lhs: 𝐏<I, T>.𝒇,
    rhs: 𝐏<I, T>.𝒇)
      -> 𝐏<I, T>.𝒇 
{
    return lhs >>- { x in { y in x + y } <^> rhs } |> trace("T & T")
}
public func & <T where T: Addable> (lhs: Parser<T>, rhs: Parser<T>) -> Parser<T> {
    return lhs >>- { x in { y in x + y } <^> rhs }
}
public func & (lhs: Parser<Character>, rhs: Parser<Character>) -> Parser<String> {
    return lhs >>- { x in { y in String([x, y]) } <^> rhs }
}
public func & (lhs: Parser<Character>, rhs: Parser<String>) -> Parser<String> {
    return lhs >>- { x in { y in String(x) + y } <^> rhs }
}
public func & <I: CollectionType, T where T: Addable> (
    lhs: 𝐏<I, T?>.𝒇,
    rhs: 𝐏<I, T>.𝒇)
      -> 𝐏<I, T>.𝒇 
{
    return lhs >>- { x in { y in x == nil ? y : x! + y } <^> rhs } |> trace("T? & T")
}
public func & <T where T: Addable> (lhs: Parser<T?>, rhs: Parser<T>) -> Parser<T> 
{
    return lhs >>- { x in { y in x == nil ? y : x! + y } <^> rhs } 
}
public func & <T where T: Addable> (lhs: Parser<T>, rhs: Parser<T?>) -> Parser<T> 
{
    return lhs >>- { x in { y in y == nil ? x : x + y! } <^> rhs } 
}
public func & <I: CollectionType, T where T: Addable> (
    lhs: 𝐏<I, T>.𝒇,
    rhs: 𝐏<I, T?>.𝒇)
      -> 𝐏<I, T>.𝒇 
{
    return lhs >>- { x in { y in y == nil ? x : x + y! } <^> rhs } |> trace("T & T?")
}
//: Helpers decrements `x` iff it is not equal to `Int.max`.
private func decrement(x: Int) -> Int {
    return (x != Int.max ? x - 1 : Int.max )
}
private func decrement(x: ClosedInterval<Int>) -> ClosedInterval<Int> {
    return decrement(x.start)...decrement(x.end)
}
/*: 
# Repetition
`*` is the cardinality combinator, taking a `𝐏<I, T>.𝒇` and producing `𝐏<I, [T]>.𝒇` 

An interval specifying the number of repetitions to perform 
* `0...n` means at most `n` repetitions; 
* `m...Int.max` means at least `m` repetitions; 
* and `m...n` means between `m` and `n` repetitions (inclusive).
*/
public func * <I: CollectionType, T>
    (parser:    𝐏<I, T>.𝒇, 
    interval:   ClosedInterval<Int>) 
             -> 𝐏<I,[T]>.𝒇 
{
    if interval.end <= 0 { 
        return { input, index in 
            input
            index
            return ([], index) 
        } 
    }
    
    let next = trace("* \(interval)") (parser) >>- 
        { x in { 
            [x] + $0 } 
            <^> (parser * decrement(interval)) }
    
    let error : 𝐏<I, [T]>.𝒇 = 
    
    { input, index in
        
        if interval.start <= 0 { 
            return ([], index) 
        } else {
            throw ParserError<I>.Error(
                message: "expected at least \(interval.start) matches", 
                index: index) 
        }
    }
    
    return trace("* : next | error") (next | error)	
}

public func * <T> 
    (parser:    Parser<T>, 
    interval:   ClosedInterval<Int>) -> Parser<[T]> 
{
    guard interval.isEmpty == false else { 
        return Parser<[T]>(fun: { throw ParserError<String>.Error(
            message: "cannot parse an empty interval of repetitions", index: $1) },
            gen: parser.gen.proliferate(interval) )
            
    }
    
    return Parser<[T]>(fun: parser.fun * (interval.start...decrement(interval.end)), gen: parser.gen.proliferate(interval))
}
public func * <T> 
    (parser:    Parser<T>, 
    interval:   HalfOpenInterval<Int>) -> Parser<[T]> 
{
    return parser * (interval.start...decrement(interval.end))
}
/*: 
Parses `parser` the number of times specified in `interval`.
An `interval` specifys the number of repetitions to perform. 
* `0..<n` means at most `n-1` repetitions; 
* `m..<Int.max` means at least `m` repetitions; 
* and `m..<n` means at least `m` and fewer than `n` repetitions; 
* `n..<n` is an error.
*/
public func * <I: CollectionType, T> 
    (parser:    𝐏<I, T >.𝒇, 
    interval:   HalfOpenInterval<Int>) 
    -> 𝐏<I,[T]>.𝒇 
{
    guard interval.isEmpty == false else { 
        return { throw ParserError<I>.Error(
                message: "cannot parse an empty interval of repetitions", index: $1) } 
    }
    
    return parser * (interval.start...decrement(interval.end))
}
//: Parses `parser` 0 or more times.
public postfix func * <I: CollectionType, T> (parser: 𝐏<I, T >.𝒇) -> 𝐏<I,[T]>.𝒇 
{
    return parser * (0..<Int.max) |> trace()
}
// `*` parses a `literal: String` zero or more times
public postfix func * (literal: String) -> 𝐏<String, [String]>.𝒇 
{
    return %(literal) * (0..<Int.max) |> trace()
}
//: Parses `parser` 1 or more times.
public postfix func + <C: CollectionType, T> (parser: 𝐏<C, T>.𝒇) -> 𝐏<C,[T]>.𝒇 
{
    return trace() (parser * (1..<Int.max))
}
public postfix func + <T> (parser: Parser<T>) -> Parser<[T]> 
{
    return parser * (1..<Int.max)
}
//: Creates a parser from `string`, and parses it 1 or more times.
public postfix func + (string: String) -> 𝐏<String, [String]>.𝒇 {
    return %(string) * (1..<Int.max)
}
//: Parses `parser` 1 or more times and drops its parse trees.
public postfix func + <C: CollectionType> (parser: 𝐏<C, Ignore>.𝒇) -> 𝐏<C, Ignore>.𝒇 {
    return ignore(parser * (1..<Int.max))
}
//: Parses `parser` 0 or more times.
public postfix func *^ <I: CollectionType, T where T: Addable, T: DefaultConstructible> 
    (parser: 𝐏<I, T >.𝒇) 
    -> 𝐏<I,T>.𝒇 
{
    return parser * (0...Int.max) |> map { $0.reduce(T(), combine: (+)) }
}
public postfix func *^ <T where T: Addable, T: DefaultConstructible> (parser: Parser<T>) -> Parser<T> {
    return Parser<T>(
        fun: parser.fun * (0...Int.max) |> map { $0.reduce(T(), combine: (+)) },
        gen: parser.gen.proliferate().fmap { $0.reduce(T(), combine: (+)) } )
}
public postfix func *^ (parser: Parser<Character>) -> Parser<String> {
    return Parser<String>(
        fun: parser.fun * (0...Int.max) |> map { String($0) },
        gen: parser.gen.proliferate().fmap { String($0) } )
}
//: Parses `parser` 0 or more times.
public postfix func +^ <I: CollectionType, T where T: Addable, T: DefaultConstructible> 
    (parser: 𝐏<I, T >.𝒇) 
    -> 𝐏<I,T>.𝒇 
{
    return parser * (1...Int.max) |> map { $0.reduce(T(), combine: (+)) }
}
public postfix func +^ <T where T: Addable, T: DefaultConstructible> 
    (parser: Parser<T>) -> Parser<T>
{
    return Parser<T>(
        fun: parser.fun * (1...Int.max) |> map { $0.reduce(T(), combine: (+)) },
        gen: parser.gen.proliferateNonEmpty().fmap { $0.reduce(T(), combine: (+)) } )
}
public postfix func +^ (parser: Parser<Character>) -> Parser<String> {
    return Parser<String>(
        fun: parser.fun * (1...Int.max) |> map { String($0) },
        gen: parser.gen.proliferateNonEmpty().fmap { String($0) } )
}
//public postfix func +^ <I: CollectionType, T where T: CollectionType, T: DefaultConstructible> 
//    (parser: 𝐏<I, T >.𝒇) 
//    -> 𝐏<I,T>.𝒇 
//{
//    return parser * (1...Int.max) |> map { $0.flatMap { $0 } }
//}
//: Creates a parser from `string`, and parses it 0 or more times.
public prefix func %
    <I: CollectionType where 
    I.Generator.Element : Equatable,
    I.SubSequence.Generator.Element : Equatable>
    (literal: I) 
    (collection: I, index: I.Index) throws -> (match: I, forwardIndex: I.Index)
{
    let literalRange = literal.startIndex ..< literal.endIndex
    tracePrint("input: \(collection), literal = \(literal), literal.count = \(literalRange.count)")
    let matchEnd = index.advancedBy(literalRange.count, limit: collection.endIndex)
    
    if collection[index ..< matchEnd].elementsEqual(literal[literalRange]) {
        tracePrint("\t\t❗️ \"\(literal)\" \(matchEnd)")
        return (literal, matchEnd) 
    } else {
        throw ParserError<I>.Error(message: "expected \"\(literal)\" at offset:\(index)", index: index)
    }
}
public func char
    (character: Character) -> Parser<Character>
{
    return Parser<Character>(
        fun: 
        { input, index in 
            
            if index < input.endIndex && input[index] == character {
                tracePrint("\t\t❗️ \"\(character)\" \(index)")
                return (character, index.successor()) 
            } else {
                throw ParserError<String>.Error(message: "expected \"\(character)\" at offset:\(index)", index: index)
            }
        },
        gen: Gen<Character>.pure(character)
    )
}

prefix operator %% {}
public prefix func %%
    (literal: String) -> Parser<String>
{
    return Parser<String>(
    fun: 
    { collection, index in 
        let literalRange = literal.startIndex ..< literal.endIndex
        tracePrint("input: \(collection), literal = \(literal), literal.count = \(literalRange.count)")
        let matchEnd = index.advancedBy(literalRange.count, limit: collection.endIndex)
        
        if collection[index ..< matchEnd].elementsEqual(literal[literalRange]) {
            tracePrint("\t\t❗️ \"\(literal)\" \(matchEnd)")
            return (literal, matchEnd) 
        } else {
            throw ParserError<String>.Error(message: "expected \"\(literal)\" at offset:\(index)", index: index)
        }
    },
    gen: Gen<String>.pure(literal)
    )
}
public prefix func %% <I: IntervalType where I.Bound == Character>
    (interval: I) -> Parser<Character> 
{
    return Parser<Character>(
        fun: 
        { input, index in
            if (index < input.endIndex && interval.contains(input[index])) {
                return (input[index], index.successor())
            } else {
                let message : String = {
                    if index < input.endIndex {
                        return "Failed: \"\(input[index])\" not found in interval (\(interval))" } 
                    else {
                        return "Failed: index: \(index) beyond end index of \"\(input)\"" } }()
                
                throw ParserError<String>.Error(
                    message: message, 
                    index: index) 
            }
        },
        gen: Gen<Character>.fromElementsIn(interval) //.fmap { (c:Character) in String(c) }
    )
}


extension String : CollectionType {}
//: Returns a parser which parses any character in `interval`.
public prefix func % <I: IntervalType where I.Bound == Character>
    (interval: I) -> 𝐏<String, String>.𝒇 
{
    return { input, index in
        if (index < input.endIndex && interval.contains(input[index])) {
            return (String(input[index]), index.successor())
        } else {
            let message : String = {
                if index < input.endIndex {
                    return "Failed: \"\(input[index])\" not found in interval (\(interval))" } 
                else {
                    return "Failed: index: \(index) beyond end index of \"\(input)\"" } }()
                    
            throw ParserError<String>.Error(
                message: message, 
                index: index) 
        }
    } |> trace("% \(interval):")
}

//: Returns a parser which maps parse trees into another type.
public func --> <I: CollectionType, T, U>(
    parser:    𝐏<I, T>.𝒇, 
    transform: (I, Range<I.Index>, T) -> U) 
    -> 𝐏<I, U>.𝒇 
{
    // TODO: Consider implementing with `map`. Broke compiler first time I tried :)
    return { 
        input, index in // (input: I, index: C.Index) -> (U, C.Index)
        let (result, newIndex) = try parser(input, index) 
        let transformedResult = transform(input, (index ..< newIndex), result)
        return (transformedResult,  newIndex)
    }
}
//: Ignores any parse trees produced by `parser`.
public func ignore<I: CollectionType, T>
    (parser: 𝐏<I, T>.𝒇) 
    -> 𝐏<I, Ignore>.𝒇 
{
    return parser --> const(Ignore())
}
//public func ignore<T>(parser: Parser<T>) -> Parser<Ignore>
//{
//    let f = (parser.fun) --> const(Ignore())
//    // Error: Cannot invoke initializer for type 'Parser<Ignore>' with an argument list of type '(fun: (String, Index) throws -> (Ignore, Index), gen: Gen<T>)'
//    return Parser<Ignore>(fun: f, gen: parser.gen)
//}
////: Ignores any parse trees produced by a parser which parses `string`.
//public func ignore(string: String) -> 𝐏<String, Ignore>.𝒇 {
//    return ignore(%string)
//}
//: `parse` function. takes a `parser` and `input` and produces a `Tree?`
public func parse <Input: CollectionType, Tree> 
    (parser: 𝐏 <Input, Tree>.𝒇, input:  Input, traceToConsole: Bool = false) -> (Tree?, String)
{
    let lastState = SwiftParseTrace; defer { SwiftParseTrace = lastState }
    if traceToConsole { SwiftParseTrace = true }
    do {
        let (result, idx) = try trace() (parser)(input, input.startIndex)
        guard idx == input.endIndex else { throw ParserError<Input>.Error(message: "Finished parsing before end of input", index: idx) }
        return (result, "result: \(result); lastIndex: \(idx); input.endIndex: \(input.endIndex)")
    } catch ParserError<Input>.Error(let msg, let idx) {
        return (nil, "\(idx): \(msg) ")
    } 
    catch let error {
        return (nil, "Undefined Error! \(error)")
    }
}
//: End of Parser Combinators. Phew!