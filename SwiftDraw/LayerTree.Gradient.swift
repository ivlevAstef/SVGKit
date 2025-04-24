//
//  LayerTree.Gradient.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 28/3/19.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

extension LayerTree {
    
    struct Gradient: Hashable {
        var stops: [Stop]
        var colorSpace: ColorSpace {
            if stops.contains(where: { $0.color.isP3 }) {
                return .p3
            }
            return .srgb
        }
        
        init(stops: [Stop]) {
            self.stops = stops
        }
        
        struct Stop: Hashable {
            var offset: Float
            var color: Color
            var opacity: Float
            
            init(offset: Float, color: Color, opacity: Float) {
                self.offset = offset
                self.color = color
                self.opacity = opacity
            }
            
            var isOpaque: Bool {
                color.isOpaque && opacity >= 1
            }
        }
        
        enum Units: Hashable {
            case userSpaceOnUse
            case objectBoundingBox
        }
        
        var isOpaque: Bool {
            stops.allSatisfy(\.isOpaque)
        }
    }
    
    struct LinearGradient: Hashable {
        var gradient: Gradient
        var start: Point
        var end: Point
        var units: Gradient.Units = .objectBoundingBox
        var transform: [Transform] = []
    }
    
    struct RadialGradient: Hashable {
        var gradient: Gradient
        var center: Point
        var radius: Float
        var endCenter: Point
        var endRadius: Float
        var units: Gradient.Units = .objectBoundingBox
        var transform: [Transform] = []
    }
}

private extension LayerTree.Color {
    var isP3: Bool {
        switch self {
        case .rgba(r: _, g: _, b: _, a: _, space: .p3):
            return true
        default:
            return false
        }
    }
}
