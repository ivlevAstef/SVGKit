//
//  Parser.XML.Filter.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 16/8/22.
//  Copyright 2022 Simon Whitty
//

extension XMLParser {
    
    func parseFilters(_ e: XML.Element) throws -> [DOM.Filter] {
        var filters = [DOM.Filter]()
        
        for n in e.children {
            if n.name == "filter" {
                filters.append(try parseFilter(n))
            } else {
                filters.append(contentsOf: try parseFilters(n))
            }
        }
        return filters
    }
    
    func parseFilter(_ e: XML.Element) throws -> DOM.Filter {
        guard e.name == "filter" else {
            throw Error.invalid
        }
        
        let nodeAtt: AttributeParser = try parseAttributes(e)
        let node = DOM.Filter(id: try nodeAtt.parseString("id"))
        
        for n in e.children {
            if let effect = try parseEffect(n) {
                node.effects.append(effect)
            }
        }
        
        return node
    }
    
    func parseEffect(_ e: XML.Element) throws -> DOM.Filter.Effect? {
        switch e.name {
        case "feGaussianBlur":
            let att: AttributeParser = try parseAttributes(e)
            return try .gaussianBlur(stdDeviation: att.parseFloat("stdDeviation"))
        default:
            return nil
        }
    }
}
