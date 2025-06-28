//
//  DOM.Element.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

import Foundation

protocol ContainerElement {
    var childElements: [DOM.GraphicsElement] { get set }
}

protocol ElementAttributes {
    var id: String? { get set }
    var `class`: String? { get set }
}

extension DOM {
    
    class Element {}
    
    class GraphicsElement: Element, ElementAttributes {
        var id: String?
        var `class`: String?
        
        var attributes = PresentationAttributes()
        var style = PresentationAttributes()
    }
    
    final class Line: GraphicsElement {
        var x1: Coordinate
        var y1: Coordinate
        var x2: Coordinate
        var y2: Coordinate
        
        init(x1: Coordinate, y1: Coordinate, x2: Coordinate, y2: Coordinate) {
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
            super.init()
        }
    }
    
    final class Circle: GraphicsElement {
        var cx: Coordinate?
        var cy: Coordinate?
        var r: Coordinate
        
        init(cx: Coordinate?, cy: Coordinate?, r: Coordinate) {
            self.cx = cx
            self.cy = cy
            self.r = r
            super.init()
        }
    }
    
    final class Ellipse: GraphicsElement {
        var cx: Coordinate?
        var cy: Coordinate?
        var rx: Coordinate
        var ry: Coordinate
        
        init(cx: Coordinate?, cy: Coordinate?, rx: Coordinate, ry: Coordinate) {
            self.cx = cx
            self.cy = cy
            self.rx = rx
            self.ry = ry
            super.init()
        }
    }
    
    final class Rect: GraphicsElement {
        var x: Coordinate?
        var y: Coordinate?
        var width: Coordinate
        var height: Coordinate
        
        var rx: Coordinate?
        var ry: Coordinate?
        
        init(x: Coordinate? = nil, y: Coordinate? = nil, width: Coordinate, height: Coordinate) {
            self.x = x
            self.y = y
            self.width = width
            self.height = height
            super.init()
        }
    }
    
    final class Polyline: GraphicsElement {
        var points: [Point]
        
        init(points: [Point]) {
            self.points = points
            super.init()
        }
    }
    
    final class Polygon: GraphicsElement {
        var points: [Point]
        
        init(points: [Point]) {
            self.points = points
            super.init()
        }
    }
    
    final class Group: GraphicsElement, ContainerElement {
        var childElements = [GraphicsElement]()
    }
}
