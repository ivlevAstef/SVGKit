//
//  CGPattern+Closure.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 28/3/19.
//  Copyright 2020 Simon Whitty
//

// swiftlint:disable all
#if canImport(CoreGraphics)
import CoreGraphics

extension CGPattern {
    
    static func make(bounds: CGRect,
                     matrix: CGAffineTransform,
                     step: CGSize,
                     tiling: CGPatternTiling,
                     isColored: Bool,
                     draw: @escaping (CGContext) -> Void) -> CGPattern {
        
        let drawPattern: CGPatternDrawPatternCallback = { info, ctx in
            let box = Unmanaged<Box>.fromOpaque(info!).takeUnretainedValue()
            box.closure(ctx)
        }
        
        let releaseInfo: CGPatternReleaseInfoCallback = { info in
            Unmanaged<Box>.fromOpaque(info!).release()
        }
        
        var callbacks = CGPatternCallbacks(version: 0,
                                           drawPattern: drawPattern,
                                           releaseInfo: releaseInfo)
        
        return CGPattern(info: Unmanaged.passRetained(Box(draw)).toOpaque(),
                         bounds: bounds,
                         matrix: matrix,
                         xStep: step.width,
                         yStep: step.height,
                         tiling: tiling,
                         isColored: isColored,
                         callbacks: &callbacks)!
    }
    
    private final class Box {
        let closure: (CGContext) -> Void
        
        init(_ closure: @escaping (CGContext) -> Void) {
            self.closure = closure
        }
    }
}

#endif
// swiftlint:enable all
