//
//  CGPath+Segment.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 10/3/17.
//  Copyright 2020 Simon Whitty
//

#if canImport(CoreGraphics)
import CoreText
import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

// swiftlint:disable multiline_arguments_brackets

extension CGPath {
    func doApply(action: @escaping (CGPathElement) -> Void) {
        var action = action
        apply(info: &action) {
            let action = $0!.bindMemory(to: ((CGPathElement) -> Void).self, capacity: 1).pointee
            action($1.pointee)
        }
    }
}

extension CGPath {
    enum Segment: Equatable {
        case move(CGPoint)
        case line(CGPoint)
        case quad(CGPoint, CGPoint)
        case cubic(CGPoint, CGPoint, CGPoint)
        case close
    }
    
    func segments() -> [Segment] {
        var segments = [Segment]()
        self.doApply {
            let p = $0
            switch p.type {
            case .moveToPoint:
                segments.append(Segment.move(p.points[0]))
            case .addLineToPoint:
                segments.append(Segment.line(p.points[0]))
            case .addQuadCurveToPoint:
                segments.append(Segment.quad(p.points[0], p.points[1]))
            case .addCurveToPoint:
                segments.append(Segment.cubic(p.points[0], p.points[1], p.points[2]))
            case .closeSubpath:
                segments.append(Segment.close)
            @unknown default:
                ()
            }
        }
        return segments
    }
}

extension CGPath {
    
    static func makeSegment(for segment: Segment) -> LayerTree.Path.Segment {
        switch segment {
        case .move(let point):
            return .move(to: .init(point))
        case .line(let point):
            return .line(to: .init(point))
        case .cubic(let control1, let control2, let point):
            return .cubic(to: .init(point), control1: .init(control1), control2: .init(control2))
        case .close:
            return .close
        case .quad(let control1, let point):
            return .cubic(to: .init(point), control1: .init(control1), control2: .init(control1))
        }
    }
    
    func makePath() -> LayerTree.Path {
        let s = segments()
        return LayerTree.Path(
            s.map(Self.makeSegment)
        )
    }
}

private extension LayerTree.Point {
    init(_ p: CGPoint) {
        self.init(LayerTree.Float(p.x),
                  LayerTree.Float((p.y)))
    }
}

extension String {
    
    func toPath(font: CTFont) -> CGPath? {
        let attributes = [kCTFontAttributeName: font]
        let attString = CFAttributedStringCreate(nil, self as CFString, attributes as CFDictionary)!
        let line = CTLineCreateWithAttributedString(attString)
        let glyphRuns = CTLineGetGlyphRuns(line)
        
        var ascent = CGFloat(0)
        var descent = CGFloat(0)
        var leading = CGFloat(0)
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
        let baseline = ascent
        
        
        let path = CGMutablePath()
        
        for idx in 0..<CFArrayGetCount(glyphRuns) {
            let val = CFArrayGetValueAtIndex(glyphRuns, idx)
            let run = unsafeBitCast(val, to: CTRun.self)
            
            for idx in 0..<CTRunGetGlyphCount(run) {
                let glyphRange = CFRange(location: idx, length: 1)
                var glyph: CGGlyph = 0
                var position: CGPoint = .zero
                CTRunGetGlyphs(run, glyphRange, &glyph)
                CTRunGetPositions(run, glyphRange, &position)
                var t = CGAffineTransform.identity
                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, &t) {
                    let t = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: position.x, ty: baseline)
                    let t1 = t.translatedBy(x: 0, y: baseline)
                    path.addPath(glyphPath, transform: t1)
                }
            }
        }
        
        return path
    }
}

#endif
// swiftlint:enable multiline_arguments_brackets
