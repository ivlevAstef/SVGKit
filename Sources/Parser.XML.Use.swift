//
//  Parser.XML.Use.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 27/2/17.
//  Copyright 2020 Simon Whitty
//

extension XMLParser {
    
    func parseUse(_ att: AttributeParser) throws -> DOM.Use {
        let use = DOM.Use(href: try att.parseUrl("xlink:href"))
        use.x = try att.parseCoordinate("x")
        use.y = try att.parseCoordinate("y")
        
        return use
    }
}
