//
//  Parser.XML.Transform.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

extension XMLParser {
    
    func parseTransform(_ data: String) throws -> [DOM.Transform] {
        
        var scanner = XMLParser.Scanner(text: data)
        var transforms = [DOM.Transform]()
        
        while let transform = try parseTransform(&scanner) {
            transforms.append(transform)
        }
        
        guard scanner.isEOF else {
            // expecting EOF
            throw Error.invalid
        }
        
        return transforms
    }
    
    private func parseTransform(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        
        if let t = try parseMatrix(&scanner) {
            return t
        } else if let t = try parseTranslate(&scanner) {
            return t
        } else if let t = try parseScale(&scanner) {
            return t
        } else if let t = try parseRotate(&scanner) {
            return t
        } else if let t = try parseSkewX(&scanner) {
            return t
        } else if let t = try parseSkewY(&scanner) {
            return t
        }
        return nil
    }
    
    private func parseMatrix(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("matrix(")) == true else {
            return nil
        }
        
        let a = try scanner.scanFloat()
        _ = try? scanner.scanString(",")
        let b = try scanner.scanFloat()
        _ = try? scanner.scanString(",")
        let c = try scanner.scanFloat()
        _ = try? scanner.scanString(",")
        let d = try scanner.scanFloat()
        _ = try? scanner.scanString(",")
        let e = try scanner.scanFloat()
        _ = try? scanner.scanString(",")
        let f = try scanner.scanFloat()
        _ = try scanner.scanString(")")
        
        return .matrix(a: a, b: b, c: c, d: d, e: e, f: f)
    }
    
    private func parseTranslate(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("translate(")) == true else {
            return nil
        }
        
        let tx = try scanner.scanFloat()
        if scanner.scanStringIfPossible(")") {
            return .translate(tx: tx, ty: 0)
        }
        
        scanner.scanStringIfPossible(",")
        let ty = try scanner.scanFloat()
        try scanner.scanString(")")
        
        return .translate(tx: tx, ty: ty)
    }
    
    private func parseScale(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("scale(")) == true else {
            return nil
        }
        
        let sx = try scanner.scanFloat()
        if scanner.scanStringIfPossible(")") {
            return .scale(sx: sx, sy: sx)
        }
        
        scanner.scanStringIfPossible(",")
        let sy = try scanner.scanFloat()
        try scanner.scanString(")")
        
        return .scale(sx: sx, sy: sy)
    }
    
    private func parseRotate(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("rotate(")) == true else {
            return nil
        }
        
        let angle = try scanner.scanFloat()
        if scanner.scanStringIfPossible(")") {
            return .rotate(angle: angle)
        }
        
        scanner.scanStringIfPossible(",")
        let cx = try scanner.scanFloat()
        scanner.scanStringIfPossible(",")
        let cy = try scanner.scanFloat()
        try scanner.scanString(")")
        
        return .rotatePoint(angle: angle, cx: cx, cy: cy)
    }
    
    private func parseSkewX(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("skewX(")) == true else {
            return nil
        }
        
        let angle = try scanner.scanFloat()
        _ = try scanner.scanString(")")
        return .skewX(angle: angle)
    }
    
    private func parseSkewY(_ scanner: inout XMLParser.Scanner) throws -> DOM.Transform? {
        guard (try? scanner.scanString("skewY(")) == true else {
            return nil
        }
        
        let angle = try scanner.scanFloat()
        _ = try scanner.scanString(")")
        return .skewY(angle: angle)
    }
}
