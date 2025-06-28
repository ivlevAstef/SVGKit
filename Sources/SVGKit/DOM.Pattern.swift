//
//  DOM.Pattern.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 26/3/19.
//  Copyright 2020 Simon Whitty
//

import Foundation

extension DOM {
    
    struct Pattern: ContainerElement {
        
        var id: String
        var x: Coordinate?
        var y: Coordinate?
        var width: Coordinate
        var height: Coordinate
        
        var patternUnits: Units?
        var patternContentUnits: Units?
        
        var childElements: [DOM.GraphicsElement] = []
        
        init(id: String, width: Coordinate, height: Coordinate) {
            self.id = id
            self.width = width
            self.height = height
        }
    }
}

extension DOM.Pattern {
    
    enum Units: String {
        case userSpaceOnUse
        case objectBoundingBox
    }
}
