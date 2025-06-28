//
//  Parser.XML.LinearGradient.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

extension XMLParser {
    
    func parseLinearGradients(_ e: XML.Element) throws -> [DOM.LinearGradient] {
        var gradients = [DOM.LinearGradient]()
        
        for n in e.children {
            if n.name == "linearGradient" {
                gradients.append(try parseLinearGradient(n))
            } else {
                gradients.append(contentsOf: try parseLinearGradients(n))
            }
        }
        return gradients
    }
    
    func parseLinearGradient(_ e: XML.Element) throws -> DOM.LinearGradient {
        guard e.name == "linearGradient" else {
            throw Error.invalid
        }
        
        let nodeAtt: AttributeParser = try parseAttributes(e)
        let node = DOM.LinearGradient(id: try nodeAtt.parseString("id"))
        node.x1 = try nodeAtt.parseCoordinate("x1")
        node.y1 = try nodeAtt.parseCoordinate("y1")
        node.x2 = try nodeAtt.parseCoordinate("x2")
        node.y2 = try nodeAtt.parseCoordinate("y2")
        
        for n in e.children where n.name == "stop" {
            let att: AttributeParser = try parseAttributes(n)
            node.stops.append(try parseLinearGradientStop(att))
        }
        
        node.gradientUnits = try nodeAtt.parseRaw("gradientUnits")
        node.href  = try? nodeAtt.parseUrl("xlink:href")
        
        if let val = try? nodeAtt.parseString("gradientTransform") {
            node.gradientTransform = try parseTransform(val)
        }
        
        return node
    }
    
    func parseLinearGradientStop(_ att: AttributeParser) throws -> DOM.LinearGradient.Stop {
        let offset: DOM.Float? = try? att.parsePercentage("offset")
        let color: DOM.Color? = try? att.parseFill("stop-color").getColor()
        let opacity: DOM.Float? = try att.parsePercentage("stop-opacity")
        return DOM.LinearGradient.Stop(offset: offset ?? 0, color: color ?? .keyword(.black), opacity: opacity ?? 1.0)
    }
}
