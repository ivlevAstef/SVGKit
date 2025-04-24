//
//  DOM.RadialGradient.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 13/8/22.
//  Copyright 2022 Simon Whitty
//

extension DOM {
    
    final class RadialGradient: Element {
        typealias Units = LinearGradient.Units
        
        var id: String
        var r: Coordinate?
        var cx: Coordinate?
        var cy: Coordinate?
        var fr: Coordinate?
        var fx: Coordinate?
        var fy: Coordinate?
        
        var stops: [Stop]
        var gradientUnits: Units?
        var gradientTransform: [Transform]
        
        // references another RadialGradient element id within defs
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

extension DOM.RadialGradient: Equatable {
    static func == (lhs: DOM.RadialGradient, rhs: DOM.RadialGradient) -> Bool {
        return lhs.id == rhs.id && lhs.stops == rhs.stops
    }
}
