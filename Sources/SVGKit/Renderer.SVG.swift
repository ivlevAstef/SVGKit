//
//  Renderer.SVG.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 7/03/22.
//  Copyright 2022 Simon Whitty
//

/// :nodoc:
struct SVGRenderer {
    
    /// Expand a Path by applying the supplied transformation
    /// - Parameters:
    ///   - path: SVG path data `M x y L x y ...`
    ///   - transform: SVG transform commands `translate(10, 20) roate(30)`
    /// - Returns: SVG path data with transform applied  `M x y L x y ...`
    static func makeExpanded(
        path: String,
        transform: String,
        precision: Int = 4
    ) throws -> String {
        
        let domPath = try XMLParser().parsePath(from: path)
        let layerPath = try LayerTree.Builder.createPath(from: domPath)
        let domTransform = try XMLParser().parseTransform(transform)
        let matrix = LayerTree.Builder
            .createTransforms(from: domTransform)
            .toMatrix()
        
        return makeDOM(path: layerPath.applying(matrix: matrix), precision: precision)
    }
    
    static func makeDOM(path: LayerTree.Path, precision: Int) -> String {
        let formatter = CoordinateFormatter(
            delimeter: .comma,
            precision: .capped(max: precision)
        )
        return path.segments
            .map { makeDOM(segment: $0, formatter: formatter) }
            .joined(separator: " ")
    }
    
    static func makeDOM(
        segment: LayerTree.Path.Segment,
        formatter: CoordinateFormatter
    ) -> String {
        switch segment {
        case .move(let point):
            let point = formatter.format(point.x, point.y)
            return "M\(point)"
        case .line(let point):
            let point = formatter.format(point.x, point.y)
            return "L\(point)"
        case .cubic(let p, let cp1, let cp2):
            let p = formatter.format(p.x, p.y)
            let cp1 = formatter.format(cp1.x, cp1.y)
            let cp2 = formatter.format(cp2.x, cp2.y)
            return "C\(cp1) \(cp2) \(p)"
        case .close:
            return "Z"
        }
    }
}
