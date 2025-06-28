//
//  LayerTree.Builder.Layer.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 21/11/18.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

// swiftlint:disable all

import Foundation

extension LayerTree.Builder {
    
    func makeShapeContents(from shape: LayerTree.Shape, with state: State) -> LayerTree.Layer.Contents {
        let stroke = makeStrokeAttributes(with: state)
        let fill = makeFillAttributes(with: state)
        return .shape(shape, stroke, fill)
    }
    
    func makeUseLayerContents(from use: DOM.Use, with state: State) throws -> LayerTree.Layer.Contents {
        guard
            let id = use.href.fragment,
            let element = svg.defs.elements[id] else {
                throw LayerTree.Error.invalid("missing referenced element: \(use.href)")
            }
        
        let l = makeLayer(from: element, inheriting: state)
        let x = use.x ?? 0.0
        let y = use.y ?? 0.0
        
        if x != 0 || y != 0 {
            l.transform.insert(.translate(tx: x, ty: y), at: 0)
        }
        
        return .layer(l)
        
    }
    
    static func makeTextContents(from text: DOM.Text, with state: State) -> LayerTree.Layer.Contents {
        var point = Point(text.x ?? 0, text.y ?? 0)
        var att = makeTextAttributes(with: state)
        att.fontName = text.attributes.fontFamily ?? att.fontName
        att.size = text.attributes.fontSize ?? att.size
        att.anchor = text.attributes.textAnchor ?? att.anchor
        point.x += makeXOffset(for: text.value, with: att)
        return .text(text.value, point, att)
    }
    
    static func makeImageContents(from image: DOM.Image) throws -> LayerTree.Layer.Contents {
        guard
            let decoded = image.href.decodedData,
            let im = LayerTree.Image(mimeType: decoded.mimeType, data: decoded.data) else {
                throw LayerTree.Error.invalid("Cannot decode image")
            }
        return .image(im)
    }
}

// swiftlint:enable all
