//
//  Renderer.SFSymbol+CGPath.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 21/8/22.
//  Copyright 2022 Simon Whitty
//

// swiftlint:disable all

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

extension SFSymbolRenderer {
    
    
    static func expandOutlines(for path: LayerTree.Path,
                               stroke: LayerTree.StrokeAttributes) -> LayerTree.Path? {
        
        var mediaBox = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData),
              let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
                  return nil
              }
        
        let provider = CGProvider()
        
        ctx.setLineWidth(provider.createFloat(from: stroke.width))
        ctx.setLineJoin(provider.createLineJoin(from: stroke.join))
        ctx.setLineCap(provider.createLineCap(from: stroke.cap))
        ctx.setMiterLimit(provider.createFloat(from: stroke.miterLimit))
        ctx.addPath(provider.createPath(from: .path(path)))
        ctx.replacePathWithStrokedPath()
        guard let cgPath = ctx.path else {
            return nil
        }
        
        return cgPath.makePath()
    }
}
#endif

// swiftlint:enable all
