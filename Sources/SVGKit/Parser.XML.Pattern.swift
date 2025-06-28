//
//  Parser.XML.Pattern.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 26/3/19.
//  Copyright 2020 Simon Whitty
//

import Foundation

extension XMLParser {
    
    func parsePattern(_ att: AttributeParser) throws -> DOM.Pattern {
        
        let id: String = try att.parseString("id")
        let width: DOM.Coordinate = try att.parseCoordinate("width")
        let height: DOM.Coordinate = try att.parseCoordinate("height")
        
        var pattern = DOM.Pattern(id: id, width: width, height: height)
        pattern.x = try att.parseCoordinate("x")
        pattern.y = try att.parseCoordinate("y")
        
        pattern.patternUnits = try att.parseRaw("patternUnits")
        pattern.patternContentUnits = try att.parseRaw("patternContentUnits")
        
        return pattern
    }
    
}
