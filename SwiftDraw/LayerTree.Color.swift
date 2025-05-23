//
//  LayerTree.Color.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 3/6/17.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

// swiftlint:disable multiline_arguments_brackets
// swiftlint:disable type_contents_order

extension LayerTree {
    enum Color: Hashable {
        
        case none
        case rgba(r: Float, g: Float, b: Float, a: Float, space: ColorSpace)
        case gray(white: Float, a: Float)
        
        static var white: Color { return Color.rgba(r: 1, g: 1, b: 1, a: 1, space: .srgb) }
        static var black: Color { return Color.rgba(r: 0, g: 0, b: 0, a: 1, space: .srgb) }
    }
    
    enum ColorSpace {
        case srgb
        case p3
    }
}

extension LayerTree.Color {
    
    static func create(from color: DOM.Color, current: DOM.Color) -> LayerTree.Color {
        switch color {
        case .none:
            return .none
        case .currentColor:
            return create(from: current, current: .none)
        case let .keyword(c):
            let rgbi = c.rgbi
            return LayerTree.Color(rgbi.0, rgbi.1, rgbi.2)
        case let .rgbi(r, g, b):
            return LayerTree.Color(r, g, b)
        case let .hex(r, g, b):
            return LayerTree.Color(r, g, b)
        case let .rgbf(r, g, b):
            return .rgba(r: Float(r),
                         g: Float(g),
                         b: Float(b),
                         a: 1.0,
                         space: .srgb)
        case let .p3(r, g, b):
            return .rgba(r: Float(r),
                         g: Float(g),
                         b: Float(b),
                         a: 1.0,
                         space: .p3)
        }
    }
    
    init(_ r: UInt8, _ g: UInt8, _ b: UInt8) {
        self = .rgba(r: Float(r) / 255.0,
                     g: Float(g) / 255.0,
                     b: Float(b) / 255.0,
                     a: 1.0,
                     space: .srgb)
    }
    
    var isOpaque: Bool {
        switch self {
        case .none:
            return false
        case .rgba(r: _, g: _, b: _, a: let a, _):
            return a >= 1.0
        case .gray(white: _, a: let a):
            return a >= 1.0
        }
    }
    
    func withAlpha(_ alpha: Float) -> LayerTree.Color {
        switch self {
        case .none:
            return .none
        case let .rgba(r: r, g: g, b: b, a: _, space):
            return .rgba(r: r,
                         g: g,
                         b: b,
                         a: alpha,
                         space: space)
        case .gray(white: let w, a: _):
            return .gray(white: w, a: alpha)
        }
    }
    
    func maybeNone() -> LayerTree.Color {
        switch self {
        case .none:
            return .none
        case .rgba(r: _, g: _, b: _, a: let a, _):
            return a > 0 ? self : .none
        case .gray(white: _, a: let a):
            return a > 0 ? self : .none
        }
    }
    
    func withMultiplyingAlpha(_ alpha: Float) -> LayerTree.Color {
        switch self {
        case .none:
            return .none
        case let .rgba(r: r, g: g, b: b, a: a, space: space):
            let newAlpha = a * alpha
            return .rgba(r: r,
                         g: g,
                         b: b,
                         a: newAlpha,
                         space: space)
        case .gray(white: let w, a: let a):
            let newAlpha = a * alpha
            return .gray(white: w, a: newAlpha)
        }
    }
}

protocol ColorConverter {
    func createColor(from color: LayerTree.Color) -> LayerTree.Color
}

struct DefaultColorConverter: ColorConverter {
    func createColor(from color: LayerTree.Color) -> LayerTree.Color {
        return color
    }
}

struct LuminanceColorConverter: ColorConverter {
    func createColor(from color: LayerTree.Color) -> LayerTree.Color {
        switch color {
        case .rgba(let r, let g, let b, let a, _):
            // sRGB Luminance to alpha
            let alpha = ((r * 0.2126) + (g * 0.7152) + (b * 0.0722)) * a
            return .gray(white: 0.0, a: alpha)
        default:
            return color
        }
    }
}
// swiftlint:enable multiline_arguments_brackets
// swiftlint:enable type_contents_order
