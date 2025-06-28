//
//  Renderer.LayerTree.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 14/6/17.
//  Copyright 2020 Simon Whitty
//

import Foundation

struct LayerTreeTypes: RendererTypes {
    typealias Float = LayerTree.Float
    typealias Point = LayerTree.Point
    typealias Size = LayerTree.Size
    typealias Rect = LayerTree.Rect
    typealias Color = LayerTree.Color
    typealias Gradient = LayerTree.Gradient
    typealias Mask = [Any]
    typealias Path = [LayerTree.Shape]
    typealias Pattern = LayerTree.Pattern
    typealias Transform = LayerTree.Transform
    typealias BlendMode = LayerTree.BlendMode
    typealias FillRule = LayerTree.FillRule
    typealias LineCap = LayerTree.LineCap
    typealias LineJoin = LayerTree.LineJoin
    typealias Image = LayerTree.Image
}

struct LayerTreeProvider: RendererTypeProvider {
    
    typealias Types = LayerTreeTypes
    
    func createFloat(from float: LayerTree.Float) -> LayerTree.Float {
        return float
    }
    
    func createPoint(from point: LayerTree.Point) -> LayerTree.Point {
        return point
    }
    
    func createSize(from size: LayerTree.Size) -> LayerTree.Size {
        return size
    }
    
    func createRect(from rect: LayerTree.Rect) -> LayerTree.Rect {
        return rect
    }
    
    func createColor(from color: LayerTree.Color) -> LayerTree.Color {
        return color
    }
    
    func createGradient(from gradient: LayerTree.Gradient) -> LayerTree.Gradient {
        return gradient
    }
    
    func createBlendMode(from mode: LayerTree.BlendMode) -> LayerTree.BlendMode {
        return mode
    }
    
    func createTransform(from transform: LayerTree.Transform.Matrix) -> LayerTree.Transform {
        return .matrix(transform)
    }
    
    func createPath(from shape: LayerTree.Shape) -> [LayerTree.Shape] {
        return [shape]
    }
    
    func createPattern(from pattern: LayerTree.Pattern, contents: [RendererCommand<Types>]) -> LayerTreeTypes.Pattern {
        return pattern
    }
    
    func createPath(from subPaths: [[LayerTree.Shape]]) -> [LayerTree.Shape] {
        return subPaths.flatMap { $0 }
    }
    
    func createPath(
        from text: String,
        at origin: LayerTree.Point,
        with attributes: LayerTree.TextAttributes
    ) -> [LayerTree.Shape]? {
        return nil
    }
    
    func createFillRule(from rule: LayerTree.FillRule) -> LayerTree.FillRule {
        return rule
    }
    
    func createLineCap(from cap: LayerTree.LineCap) -> LayerTree.LineCap {
        return cap
    }
    
    func createLineJoin(from join: LayerTree.LineJoin) -> LayerTree.LineJoin {
        return join
    }
    
    func createImage(from image: LayerTree.Image) -> LayerTree.Image? {
        return image
    }
    
    func getBounds(from shape: LayerTree.Shape) -> LayerTree.Rect {
        return LayerTree.Rect(x: 0, y: 0, width: 0, height: 0)
    }
}
