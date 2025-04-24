//
//  Parser.XML.Text.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

import Foundation

extension XMLParser {
    
    func parseText(_ att: AttributeParser, element: XML.Element) throws -> DOM.Text? {
        guard
            let text = element.innerText?.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty else {
                return nil
            }
        
        return try parseText(att, value: text)
    }
    
    func parseAnchor(_ att: AttributeParser, element: XML.Element) throws -> DOM.Anchor? {
        let anchor = DOM.Anchor()
        anchor.href = try att.parseUrl("href")
        anchor.childElements = try parseContainerChildren(element)
        return anchor
    }
    
    func parseText(_ att: AttributeParser, value: String) throws -> DOM.Text {
        let element = DOM.Text(value: value)
        element.x = try att.parseCoordinate("x")
        element.y = try att.parseCoordinate("y")
        return element
    }
}
