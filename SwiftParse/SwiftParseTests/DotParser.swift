//
//  DotParser.swift
//  SwiftParse
//
//  Created by Daniel Asher on 09/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
import func Swiftx.|>
import func Swiftx.fixt

prefix operator ≠ {}
public prefix func ≠ <I: CollectionType, T>
    (parser: 𝐏<I, T>.𝒇) 
    -> 𝐏<I, Ignore>.𝒇 
{
    return ignore(parser)
}

prefix operator § {}
public prefix func § (literal: String) -> 𝐏<String, String>.𝒇 {
    return %literal |> P.token
}

public struct P {

    static let whitespace  = %" " | %"\t" | %"\n"
    //: Our `token` defines whitespace handling.
    static func token(parser: 𝐏<String, String>.𝒇 ) -> 𝐏<String, String>.𝒇 {
        return parser ++ ignore(whitespace*) 
    }

    static let separator   = §";" | §","
    static let sep         = ≠separator|?
    static let lower       = %("a"..."z")
    static let upper       = %("A"..."Z")
    static let digit       = %("0"..."9")

    // simpleId cannot start with a digit.
    static let simpleId = (lower | upper | %"_") & (lower | upper | digit | %"_")*^

    static let number = %"." & digit+^ | (digit+^ & (%"." & digit*^)|?)
    static let decimal = (%"-")|? & number
    
    static let quotedChar   = %"\\\"" | %"\\\\" | not("\"") 
    static let quotedId     = %"\"" & quotedChar+^ & %"\""
    static let ID           = (simpleId | decimal | quotedId) |> P.token
    static let id_equality  = ID ++ §"=" ++ ID ++ sep |> map { Attribute(name: $0, value: $1.1) }
    
    static let attr_list    = (§"[" <* id_equality+ *> §"]")+ |> map { $0.flatMap { $0 } }
    static let node_id      = ID
    static let edgeop       = §"->" | §"--" |> map { EdgeOp(rawValue: $0)! }
    
    static let attr_target = §"graph" | §"node" | §"edge"
        |> map { TargetType(rawValue: $0)! }
        
    static let attr_stmt = attr_target ++ attr_list
        |> map { t, xs in Statement.Attr(target: t, attributes: xs) }
        
    static let node_stmt = node_id ++ attr_list*
        |> map { name, xs in Statement.Node(id: name, attributes: xs.flatMap { $0 } ) }
    
    static let edgeRHS :  𝐏<String, [EdgeRHS]>.𝒇    = fixt { edgeRHS in
        let edgeSpec = edgeop ++ node_id    |> map { EdgeRHS(edgeOp: $0, target: $1) }
        return edgeSpec ++ edgeRHS*         |> map { [$0] + $1.flatMap { $0 } }
    }
    
    static let opt_attr = attr_list|? |> map { $0 ?? [] }
       
    static let edge_stmt = node_id ++ edgeRHS ++ opt_attr
        |> map { (s, es) in Statement.Edge(source: s, edgeRHS: es.0, attributes: es.1) }
        
    static let stmt_list : StatementsParser = fixt { stmt_list in
        
        let id_stmt = id_equality |> map { Statement.Property($0) }
        
        let subgraph_id =  §"subgraph" ++ ID|? |> map { $1 }
        
        let subgraph = subgraph_id ++ ≠(§"{") ++ stmt_list ++ ≠(§"}") 
            |> map { Statement.Subgraph(id: $0, stmts: $1) }
        
        // TODO: Figure out if the ordering of alternatives is essential
        let stmt = id_stmt | edge_stmt | attr_stmt | subgraph | node_stmt 
        
        return stmt ++ ≠(§";")|? ++ stmt_list*
            |> map { x, xs in [x] + xs.flatMap { $0 } }
    }
    
    static let graph_type = §"graph" | §"digraph" 
            |> map { GraphType(rawValue: $0)! }
            
    static let graph_id = graph_type ++ ID|?
    
    static let graph = graph_id ++ ≠(§"{") ++ stmt_list *> §"}"
        |> map { id, ss in Graph(type: id.0, id: id.1, stmt_list: ss) }

}






