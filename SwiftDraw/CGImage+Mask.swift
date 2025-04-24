//
//  CGImage+Mask.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/3/19.
//  Copyright 2020 Simon Whitty
//


#if canImport(CoreGraphics)
import CoreGraphics
import Foundation

// swiftlint:disable all

func CGColorSpaceCreateExtendedGray() -> CGColorSpace {
    return CGColorSpace(name: CGColorSpace.extendedGray)!
}

extension CGImage {
    
    static func makeMask(size: CGSize, draw: (CGContext) -> Void) -> CGImage {
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        var data = Data(repeating: 0xff, count: width * height)
        data.withUnsafeMutableBytes {
            let ctx = CGContext(data: $0.baseAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width,
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: 0)!
            draw(ctx)
        }
        
        return CGImage(maskWidth: width,
                       height: height,
                       bitsPerComponent: 8,
                       bitsPerPixel: 8,
                       bytesPerRow: width,
                       provider: CGDataProvider(data: data as CFData)!,
                       decode: nil,
                       shouldInterpolate: true)!
    }
}

#endif

// swiftlint:enable all
