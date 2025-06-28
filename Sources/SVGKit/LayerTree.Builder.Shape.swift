//
//  LayerTree.Builder.Shape.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 21/11/18.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

// swiftlint:disable all

import Foundation

extension LayerTree.Builder {
    
    static func makeShape(from element: DOM.GraphicsElement) -> LayerTree.Shape? {
        if let line = element as? DOM.Line {
            let from = Point(line.x1, line.y1)
            let to = Point(line.x2, line.y2)
            return .line(between: [from, to])
        } else if let circle = element as? DOM.Circle {
            return .ellipse(within: makeRect(from: circle))
        } else if let ellipse = element as? DOM.Ellipse {
            return .ellipse(within: makeRect(from: ellipse))
        } else if let rect = element as? DOM.Rect {
            let radii = makeRadii(rx: rect.rx, ry: rect.ry)
            return .rect(within: makeRect(from: rect), radii: radii)
        } else if let polyline = element as? DOM.Polyline {
            return .line(between: polyline.points.map { Point($0.x, $0.y) })
        } else if let polygon = element as? DOM.Polygon {
            return .polygon(between: polygon.points.map { Point($0.x, $0.y) })
        } else if let domPath = element as? DOM.Path,
                  let path = try? createPath(from: domPath) {
            return .path(path)
        }
        
        return nil
    }
    
    static func makeRect(from rect: DOM.Rect) -> LayerTree.Rect {
        return LayerTree.Rect(x: rect.x ?? 0,
                              y: rect.y ?? 0,
                              width: rect.width,
                              height: rect.height)
    }
    
    static func makeRect(from ellipse: DOM.Ellipse) -> LayerTree.Rect {
        let cx = ellipse.cx ?? 0
        let cy = ellipse.cy ?? 0
        return LayerTree.Rect(x: cx - ellipse.rx,
                              y: cy - ellipse.ry,
                              width: ellipse.rx * 2,
                              height: ellipse.ry * 2)
    }
    
    static func makeRect(from circle: DOM.Circle) -> LayerTree.Rect {
        let cx = circle.cx ?? 0
        let cy = circle.cy ?? 0
        return LayerTree.Rect(x: cx - circle.r,
                              y: cy - circle.r,
                              width: circle.r * 2,
                              height: circle.r * 2)
    }
    
    static func makeRadii(rx: DOM.Float?, ry: DOM.Float?) -> LayerTree.Size {
        LayerTree.Size(rx ?? ry ?? 0, ry ?? rx ?? 0)
    }
}

// swiftlint:enable all
