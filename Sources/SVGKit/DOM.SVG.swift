//
//  DOM.SVG.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 11/2/17.
//  Copyright 2020 Simon Whitty
//

extension DOM {
    final class SVG: GraphicsElement, ContainerElement {
        var width: Length
        var height: Length
        var viewBox: ViewBox?
        
        var childElements = [GraphicsElement]()
        
        var styles = [StyleSheet]()
        var defs = Defs()
        
        init(width: Length, height: Length) {
            self.width = width
            self.height = height
        }
        
        struct ViewBox: Equatable {
            var x: Coordinate
            var y: Coordinate
            var width: Coordinate
            var height: Coordinate
        }
        
        struct Defs {
            var clipPaths = [ClipPath]()
            var linearGradients = [LinearGradient]()
            var radialGradients = [RadialGradient]()
            var masks = [Mask]()
            var patterns = [Pattern]()
            var filters = [Filter]()
            
            var elements = [String: GraphicsElement]()
        }
    }
    
    struct ClipPath: ContainerElement {
        var id: String
        var childElements = [GraphicsElement]()
    }
    
    struct Mask: ContainerElement {
        var id: String
        var childElements = [GraphicsElement]()
    }
    
    struct StyleSheet {
        
        enum Selector: Hashable {
            case element(String)
            case id(String)
            case `class`(String)
        }
        
        var attributes: [Selector: PresentationAttributes] = [:]
    }
}
