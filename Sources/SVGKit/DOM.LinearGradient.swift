//
//  DOM.LinearGradient.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

extension DOM {
    
    final class LinearGradient: Element {
        
        var id: String
        var x1: Coordinate?
        var y1: Coordinate?
        var x2: Coordinate?
        var y2: Coordinate?
        
        var stops: [Stop]
        var gradientUnits: Units?
        var gradientTransform: [Transform]
        
        // references another LinearGradient element id within defs
        var href: URL?
        
        init(id: String) {
            self.id = id
            self.stops = []
            self.gradientTransform = []
        }
        
        struct Stop: Equatable {
            var offset: Float
            var color: Color
            var opacity: Float
            
            init(offset: Float, color: Color, opacity: Opacity = 1.0) {
                self.offset = offset
                self.color = color
                self.opacity = opacity
            }
        }
    }
}

extension DOM.LinearGradient: Equatable {
    static func == (lhs: DOM.LinearGradient, rhs: DOM.LinearGradient) -> Bool {
        return lhs.id == rhs.id &&
        lhs.x1 == rhs.x1 &&
        lhs.y1 == rhs.y1 &&
        lhs.x2 == rhs.x2 &&
        lhs.y2 == rhs.y2 &&
        lhs.stops == rhs.stops
    }
}

extension DOM.LinearGradient {
    
    enum Units: String {
        case userSpaceOnUse
        case objectBoundingBox
    }
}
