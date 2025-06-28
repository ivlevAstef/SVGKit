//
//  LayerTree.Builder.Text.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 26/8/22.
//  Copyright 2022 Simon Whitty
//

// swiftlint:disable all
// Convert a DOM.SVG into a layer tree

import Foundation
#if canImport(CoreText)
import CoreText
#endif

extension LayerTree.Builder {
    
#if canImport(CoreText)
    static func makeXOffset(for text: String, with attributes: LayerTree.TextAttributes) -> LayerTree.Float {
        let font = CTFontCreateWithName(attributes.fontName as CFString,
                                        CGFloat(attributes.size),
                                        nil)
        guard let bounds = text.toPath(font: font)?.boundingBoxOfPath else { return 0 }
        switch attributes.anchor {
        case .start:
            return LayerTree.Float(bounds.minX)
        case .middle:
            return LayerTree.Float(-bounds.midX)
        case .end:
            return LayerTree.Float(-bounds.maxX)
        }
    }
#else
    static func makeXOffset(for text: String, with attributes: LayerTree.TextAttributes) -> LayerTree.Float {
        return 0
    }
#endif
        
}

// swiftlint:enable all
