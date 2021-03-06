//
//  DotAST.swift
//  SwiftParse
//
//  Created by Daniel Asher on 09/09/2015.
//  Copyright © 2015 StoryShare. All rights reserved.
//
//: Syntax Tree Types
public typealias ID = String

public struct Attribute {
    let name: String
    let value: String
    public init(name: String, value: String) { self.name = name; self.value = value}
}

public enum AttributeType : String {
    case Graph  = "graph"
    case Node   = "node"
    case Edge   = "edge"
}

public enum EdgeOp : String {
    case Directed   = "->"
    case Undirected = "--"   
}

public struct EdgeRHS {
    let edgeOp : EdgeOp
    let target : ID
}

public enum Statement {
    case Node(id: ID, attributes: [Attribute])
    case Edge(source: ID, edgeRHS: [EdgeRHS], attributes: [Attribute])
    case Attr(target: AttributeType, attributes: [Attribute])
    case Property(Attribute)
    case Subgraph(id: ID?, stmts: [Statement])
}

// Evaluate `Term`, which allows for edge's to support subgraphs, e.g. (node_id | subgraph) EdgeRHS
public enum Term {
    case NodeId(id: ID)
    case NodeStmt(id: ID, attributes: [Attribute])
    case AttrStmt(target: AttributeType, attributes: [Attribute])
    case IdEquality(Attribute)
    case Subgraph(id: ID?, stmts: [Term])
    // edgeRHS	:	edgeop (node_id | subgraph) [ edgeRHS ]
    indirect case EdgeRHS(edgeOp: EdgeOp, target: Term)
    // edge_stmt	:	(node_id | subgraph) edgeRHS [ attr_list ]
    indirect case Edge(source: Term, edgeRHS: [Term], attributes: [Attribute])

}
//: ## Root `Graph`
public enum GraphType : String {
    case Directed       = "digraph"
    case Undirected     = "graph"
}

public struct Graph {
    let type        : GraphType
    let id          : String?
    let stmt_list   : [Statement]
}
//: Printable `extensions`

public extension Statement {
    var toString : String {
        switch self {
        case let Node(id, attrs): 
            return "\(self)"
        case let Edge(source, edgeRHS, attributes):
            return "\(self)"
        case let Attr(target, attributes):
            return "\(self)"
        case let Property(attr):
            return "\(self)"
        case let Subgraph(id, stmts):
            return "\(self)"
        }
    }
}

extension Graph {
    public var toString : String {
        let id = self.id ?? ""
        let stmts_render = self.stmt_list.reduce("") 
            { str, stmt -> String in
                return str + stmt.toString
        }
        return "\(type) \(id) { \(stmts_render) }"
    }
}

extension Attribute : CustomStringConvertible {
    public var description : String {
        return "\(name) = \(value)"
    }
}

extension AttributeType : CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension EdgeOp : CustomStringConvertible {
    public var description : String {
        return self.rawValue
    }
}

extension EdgeRHS : CustomStringConvertible {
    public var description: String {
        return "\(edgeOp.rawValue) \(target)"
    }
}

extension Statement : CustomStringConvertible {
    public var description : String {
        switch self {
        case Node(let id, let xs): return "Node ( \(id), \(xs) )\n"
        case Edge(let src, let es, let xs): return "Edge ( \(src), \(es), \(xs) )\n"
        case Attr(let tgt, let xs): return "Attr ( \(tgt), \(xs) )\n"
        case Property(let attribute): return "Property ( \(attribute) )\n"
        case Subgraph(let id, let stmts):
            return "Subgraph ( id: \"" + (id ?? "") + "\", stmts: \(stmts))"
        }
    }
}

public typealias StatementsParser = 𝐏<String, [Statement]>.𝒇

extension GraphType : CustomStringConvertible {
    public var description : String {
        return self.rawValue
    }
}

extension Graph : CustomStringConvertible {
    public var description : String {
        let idstr = self.id ?? ""
        return "Graph ( type: \"\(self.type)\", id: \"\(idstr)\", stmt_list: \n\t\(self.stmt_list) )"
    }
}
