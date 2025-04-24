//
//  LayerTree.Layer.swift
//  SwiftDraw
//

extension LayerTree {
    final class Layer: Equatable {
        var contents: [Contents] = []
        var opacity: Float = 1.0
        var transform: [Transform] = []
        var clip: [Shape] = []
        var clipRule: FillRule?
        var mask: Layer?
        var filters: [Filter] = []
        
        enum Contents: Equatable {
            case shape(Shape, StrokeAttributes, FillAttributes)
            case image(Image)
            case text(String, Point, TextAttributes)
            case layer(Layer)
        }
        
        func appendContents(_ contents: Contents) {
            switch contents {
            case .layer(let l):
                guard l.contents.isEmpty == false else {
                    return
                }
                
                // if layer is simple, we can ignore all other properties
                if let simple = l.simpleContents {
                    self.contents.append(simple)
                } else {
                    self.contents.append(.layer(l))
                }
            default:
                self.contents.append(contents)
            }
        }
        
        var simpleContents: Contents? {
            guard self.contents.count == 1,
                  let first = self.contents.first,
                  opacity == 1.0,
                  transform == [],
                  clip == [],
                  mask == nil,
                  filters == [] else { return nil }
            
            return first
        }
        
        static func == (lhs: Layer, rhs: Layer) -> Bool {
            return lhs.contents == rhs.contents &&
            lhs.opacity == rhs.opacity &&
            lhs.transform == rhs.transform &&
            lhs.clip == rhs.clip &&
            lhs.mask == rhs.mask &&
            lhs.filters == rhs.filters
        }
    }
    
    struct StrokeAttributes: Equatable {
        var color: Stroke
        var width: Float
        var cap: LineCap
        var join: LineJoin
        var miterLimit: Float
        
        enum Stroke: Equatable {
            case color(Color)
            case linearGradient(LinearGradient)
            case radialGradient(RadialGradient)
            
            static let none = Stroke.color(.none)
        }
    }
    
    struct FillAttributes: Equatable {
        var fill: Fill = .color(.none)
        var opacity: Float = 1.0
        var rule: FillRule
        
        init(color: Color, rule: FillRule) {
            self.fill = .color(color)
            self.rule = rule
        }
        
        init(pattern: Pattern, rule: FillRule, opacity: Float) {
            self.fill = .pattern(pattern)
            self.rule = rule
            self.opacity = opacity
        }
        
        init(linear gradient: LinearGradient, rule: FillRule, opacity: Float) {
            self.fill = .linearGradient(gradient)
            self.rule = rule
            self.opacity = opacity
        }
        
        init(radial gradient: RadialGradient, rule: FillRule, opacity: Float) {
            self.fill = .radialGradient(gradient)
            self.rule = rule
            self.opacity = opacity
        }
        
        enum Fill: Equatable {
            case color(Color)
            case pattern(Pattern)
            case linearGradient(LinearGradient)
            case radialGradient(RadialGradient)
            
            static let none = Fill.color(.none)
        }
    }
    
    struct TextAttributes: Equatable {
        var color: Color
        var fontName: String
        var size: Float
        var anchor: DOM.TextAnchor
    }
}
