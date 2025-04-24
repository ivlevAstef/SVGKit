//
//  LayerTree.Transform.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 3/6/17.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

// swiftlint:disable all

extension LayerTree {
    
    enum Transform: Hashable {
        case matrix(Matrix)
        case scale(sx: Float, sy: Float)
        case translate(tx: Float, ty: Float)
        case rotate(radians: Float)
        
        static var identity: Transform { .matrix(.identity) }
        
        static func skewX(angle radians: Float) -> Transform {
            let m = Matrix(a: 1, b: 0, c: tan(radians), d: 1, tx: 0, ty: 0)
            return .matrix(m)
        }
        
        static func skewY(angle radians: Float) -> Transform {
            let m = Matrix(a: 1, b: tan(radians), c: 0, d: 1, tx: 0, ty: 0)
            return .matrix(m)
        }
        
        struct Matrix: Hashable {
            var a: Float
            var b: Float
            var c: Float
            var d: Float
            var tx: Float
            var ty: Float
            
            static let identity = Matrix(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        }
    }
}

extension LayerTree.Transform {
    func toMatrix() -> Matrix {
        switch self {
        case .matrix(let m):
            return m
        case .scale(let sx, let sy):
            return Matrix(a: sx, b: 0, c: 0, d: sy, tx: 0, ty: 0)
        case .translate(let tx, let ty):
            return Matrix(a: 1, b: 0, c: 0, d: 1, tx: tx, ty: ty)
        case .rotate(let radians):
            let sine = sin(radians)
            let cosine = cos(radians)
            return Matrix(a: cosine, b: sine, c: -sine, d: cosine, tx: 0, ty: 0)
        }
    }
}

extension LayerTree.Transform.Matrix {
    func concatenated(_ other: LayerTree.Transform.Matrix) -> LayerTree.Transform.Matrix {
        let (t, m) = (self, other)
        return LayerTree.Transform.Matrix(a: (t.a * m.a) + (t.b * m.c),
                                          b: (t.a * m.b) + (t.b * m.d),
                                          c: (t.c * m.a) + (t.d * m.c),
                                          d: (t.c * m.b) + (t.d * m.d),
                                          tx: (t.tx * m.a) + (t.ty * m.c) + m.tx,
                                          ty: (t.tx * m.b) + (t.ty * m.d) + m.ty)
    }
}

extension LayerTree.Transform.Matrix {
    
    func transform(point: LayerTree.Point) -> LayerTree.Point {
        LayerTree.Point(
            (a * point.x) + (c * point.y) + tx,
            (b * point.x) + (d * point.y) + ty
        )
    }
}

extension Array where Element == LayerTree.Transform {
    func toMatrix() -> LayerTree.Transform.Matrix {
        reversed().reduce(LayerTree.Transform.identity.toMatrix()) {
            $0.concatenated($1.toMatrix())
        }
    }
}

// swiftlint:enable all
