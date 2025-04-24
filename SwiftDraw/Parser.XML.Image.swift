//
//  Parser.XML.Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

extension XMLParser {
    
    func parseImage(_ att: AttributeParser) throws -> DOM.Image {
        let href: DOM.URL = try att.parseUrl("xlink:href")
        let width: DOM.Coordinate = try att.parseCoordinate("width")
        let height: DOM.Coordinate = try att.parseCoordinate("height")
        
        let use = DOM.Image(href: href, width: width, height: height)
        use.x = try att.parseCoordinate("x")
        use.y = try att.parseCoordinate("y")
        
        return use
    }
}
