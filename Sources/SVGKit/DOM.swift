//
//  DOM.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

import Foundation

// swiftlint:disable all

enum DOM { /* namespace */ }

extension DOM {
    typealias Float = Swift.Float
    typealias Coordinate = Swift.Float
    typealias Length = Swift.Int
    typealias Opacity = Swift.Float
    typealias Bool = Swift.Bool
    typealias URL = Foundation.URL
}

extension DOM {
    struct Point: Equatable {
        var x: Coordinate
        var y: Coordinate
        
        init(_ x: Coordinate, _ y: Coordinate) {
            self.x = x
            self.y = y
        }
    }
    
    enum Fill: Equatable {
        case url(URL)
        case color(DOM.Color)
        
        func getColor() throws -> DOM.Color {
            switch self {
            case .url:
                throw Error.missing("Color")
            case .color(let c):
                return c
            }
        }
    }
    
    enum FillRule: String {
        case nonzero
        case evenodd
    }
    
    enum DisplayMode: String {
        case none
        case inline
    }
    
    enum LineCap: String {
        case butt
        case round
        case square
    }
    
    enum LineJoin: String {
        case miter
        case round
        case bevel
    }
    
    enum TextAnchor: String {
        case start
        case middle
        case end
    }
    
    enum Transform: Equatable {
        case matrix(a: Float, b: Float, c: Float, d: Float, e: Float, f: Float)
        case translate(tx: Float, ty: Float)
        case scale(sx: Float, sy: Float)
        case rotate(angle: Float)
        case rotatePoint(angle: Float, cx: Float, cy: Float)
        case skewX(angle: Float)
        case skewY(angle: Float)
    }
    
    enum Error: Swift.Error {
        case missing(String)
    }
}

// swiftlint:enable all
