//
//  Parser.XML.RadialGradient.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 13/8/22.
//  Copyright 2022 Simon Whitty
//

extension XMLParser {
    
    func parseRadialGradients(_ e: XML.Element) throws -> [DOM.RadialGradient] {
        var gradients = [DOM.RadialGradient]()
        
        for n in e.children {
            if n.name == "radialGradient" {
                gradients.append(try parseRadialGradient(n))
            } else {
                gradients.append(contentsOf: try parseRadialGradients(n))
            }
        }
        return gradients
    }
    
    func parseRadialGradient(_ e: XML.Element) throws -> DOM.RadialGradient {
        guard e.name == "radialGradient" else {
            throw Error.invalid
        }
        
        let nodeAtt: AttributeParser = try parseAttributes(e)
        let node = DOM.RadialGradient(id: try nodeAtt.parseString("id"))
        node.r = try? nodeAtt.parseCoordinate("r")
        node.cx = try? nodeAtt.parseCoordinate("cx")
        node.cy = try? nodeAtt.parseCoordinate("cy")
        node.fr = try? nodeAtt.parseCoordinate("fr")
        node.fx = try? nodeAtt.parseCoordinate("fx")
        node.fy = try? nodeAtt.parseCoordinate("fy")
        
        for n in e.children where n.name == "stop" {
            let att: AttributeParser = try parseAttributes(n)
            node.stops.append(try parseRadialGradientStop(att))
        }
        
        node.gradientUnits = try nodeAtt.parseRaw("gradientUnits")
        node.href  = try? nodeAtt.parseUrl("xlink:href")
        
        if let val = try? nodeAtt.parseString("gradientTransform") {
            node.gradientTransform = try parseTransform(val)
        }
        
        return node
    }
    
    func parseRadialGradientStop(_ att: AttributeParser) throws -> DOM.RadialGradient.Stop {
        let offset: DOM.Float? = try? att.parsePercentage("offset")
        let color: DOM.Color? = try? att.parseFill("stop-color").getColor()
        let opacity: DOM.Float? = try att.parsePercentage("stop-opacity")
        return DOM.RadialGradient.Stop(offset: offset ?? 0, color: color ?? .keyword(.black), opacity: opacity ?? 1.0)
    }
}
