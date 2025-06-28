//
//  DOM.Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 7/3/17.
//  Copyright 2020 Simon Whitty
//

extension DOM {
    final class Image: GraphicsElement {
        var href: URL
        var width: Coordinate
        var height: Coordinate
        
        var x: Coordinate?
        var y: Coordinate?
        
        init(href: URL, width: Coordinate, height: Coordinate) {
            self.href = href
            self.width = width
            self.height = height
            super.init()
        }
    }
}
