//
//  UIImage+Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 24/5/17.
//  Copyright 2020 Simon Whitty
//

// swiftlint:disable all

#if canImport(UIKit)
import UIKit

extension UIImage {
    
    convenience init?(svgNamed name: String, in bundle: Bundle = .main, options: SVG.Options = .default) {
        guard let image = SVG(named: name, in: bundle, options: options) else { return nil }
        self.init(image)
    }
    
    @objc(initWithSVGData:)
    convenience init?(svgData: Data) {
        guard let image = SVG(data: svgData) else { return nil }
        self.init(image)
    }
    
    @objc(initWithContentsOfSVGFile:)
    convenience init?(contentsOfSVGFile path: String) {
        guard let image = SVG(fileURL: URL(fileURLWithPath: path)) else { return nil }
        self.init(image)
    }
    
    @objc(svgNamed:)
    static func _svgNamed(_ name: String) -> UIImage? {
        UIImage(svgNamed: name, in: .main)
    }
    
    @objc(svgNamed:inBundle:)
    static func _svgNamed(_ name: String, in bundle: Bundle) -> UIImage? {
        UIImage(svgNamed: name, in: bundle)
    }
    
    convenience init(_ image: SVG) {
        let image = image.rasterize()
        self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
    }
}

extension SVG {
    func rasterize() -> UIImage {
        return rasterize(with: size)
    }
    
    private func makeFormat() -> UIGraphicsImageRendererFormat {
        let f = UIGraphicsImageRendererFormat.preferred()
        f.preferredRange = .automatic
        return f
    }
    
    func rasterize(with size: CGSize? = nil, scale: CGFloat = 0, insets: UIEdgeInsets = .zero) -> UIImage {
        let insets = Insets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        let (bounds, pixelsWide, pixelsHigh) = makeBounds(size: size, scale: 1, insets: insets)
        let f = makeFormat()
        f.scale = scale
        f.opaque = false
        let r = UIGraphicsImageRenderer(size: CGSize(width: pixelsWide, height: pixelsHigh), format: f)
        return r.image {
            $0.cgContext.draw(self, in: bounds)
        }
    }
    
    func pngData(size: CGSize? = nil, scale: CGFloat = 0, insets: UIEdgeInsets = .zero) throws -> Data {
        let image = rasterize(with: size, scale: scale, insets: insets)
        guard let data = image.pngData() else {
            throw Error("Failed to create png data")
        }
        return data
    }
    
    func jpegData(
        size: CGSize? = nil,
        scale: CGFloat = 0,
        compressionQuality quality: CGFloat = 1,
        insets: UIEdgeInsets = .zero
    ) throws -> Data {
        let image = rasterize(with: size, scale: scale, insets: insets)
        guard let data = image.jpegData(compressionQuality: quality) else {
            throw Error("Failed to create jpeg data")
        }
        return data
    }
}

extension SVG {
    
    func jpegData(size: CGSize?, scale: CGFloat, insets: Insets) throws -> Data {
        let insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        return try jpegData(size: size, scale: scale, insets: insets)
    }
    
    func pngData(size: CGSize?, scale: CGFloat, insets: Insets) throws -> Data {
        let insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        return try pngData(size: size, scale: scale, insets: insets)
    }
    
    func makeBounds(
        size: CGSize?,
        scale: CGFloat,
        insets: Insets
    ) -> (bounds: CGRect, pixelsWide: Int, pixelsHigh: Int) {
        let scale = scale == 0 ? UIScreen.main.scale : scale
        return Self.makeBounds(size: size, defaultSize: self.size, scale: scale, insets: insets)
    }
    
    private struct Error: LocalizedError {
        var errorDescription: String?
        
        init(_ message: String) {
            self.errorDescription = message
        }
    }
}

#endif

// swiftlint:enable all
