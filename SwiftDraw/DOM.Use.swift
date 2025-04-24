//
//  DOM.Use.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 27/2/17.
//  Copyright 2020 Simon Whitty
//

extension DOM {
    final class Use: GraphicsElement {
        var x: Coordinate?
        var y: Coordinate?
        
        // references element ids within defs
        var href: URL
        
        init(href: URL) {
            self.href = href
        }
    }
}
