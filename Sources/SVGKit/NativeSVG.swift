//
//  SVG.swift
//  SVGKit
//
//  Created by ks.ursul on 26.09.2022.
//

import Darwin
import Foundation
import UIKit

@objc
class CGSVGDocument: NSObject { }

private var CGSVGDocumentRetain: (
    @convention(c) (CGSVGDocument?) -> Unmanaged<CGSVGDocument>?
) = load("CGSVGDocumentRetain")
private var CGSVGDocumentRelease: (
    @convention(c) (CGSVGDocument?) -> Void
) = load("CGSVGDocumentRelease")
private var CGSVGDocumentCreateFromData: (
    @convention(c) (CFData?, CFDictionary?) -> Unmanaged<CGSVGDocument>?
) = load("CGSVGDocumentCreateFromData")
private var CGContextDrawSVGDocument: (
    @convention(
        c
    ) (CGContext?, CGSVGDocument?) -> Void
) = load("CGContextDrawSVGDocument")
private var CGSVGDocumentGetCanvasSize: (
    @convention(c) (CGSVGDocument?) -> CGSize
) = load("CGSVGDocumentGetCanvasSize")

private typealias ImageWithCGSVGDocument = @convention(c) (AnyObject, Selector, CGSVGDocument) -> UIImage
private var ImageWithCGSVGDocumentSEL: Selector = NSSelectorFromString("_imageWithCGSVGDocument:")

private let CoreSVG = dlopen("/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG", RTLD_NOW)

func load<T>(_ name: String) -> T {
    unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
}

/// Класс для рендеринга SVG из строки или Data
/// Используется нативный фреймворк. Корректно работает начиная с iOS15.
public final class NativeSVG {

    let document: CGSVGDocument

    /// Размер
    public var size: CGSize {
        CGSVGDocumentGetCanvasSize(document)
    }

    /// Получить SVG из строки
    public convenience init?(_ value: String) {
        guard let data = value.data(using: .utf8) else {
            return nil
        }
        self.init(data)
    }
    
    /// Получить SVG из Data
    public init?(_ data: Data) {
        guard let document = CGSVGDocumentCreateFromData(data as CFData, nil)?.takeUnretainedValue() else {
            return nil
        }
        guard CGSVGDocumentGetCanvasSize(document) != .zero else {
            return nil
        }
        self.document = document
    }
    
    
    deinit {
        CGSVGDocumentRelease(document)
    }
    
    /// Получить картинку из  SVG-документа
    public func image() -> UIImage? {
        let ImageWithCGSVGDocument = unsafeBitCast(
            UIImage.self.method(for: ImageWithCGSVGDocumentSEL),
            to: ImageWithCGSVGDocument.self
        )
        let image = ImageWithCGSVGDocument(UIImage.self, ImageWithCGSVGDocumentSEL, document)
        return image
    }
    
    /// Отрисовать SVG на графическом контексте
    public func draw(in context: CGContext) {
        draw(in: context, size: size)
    }
    
    /// Отрисовать SVG заданного размера на графическом контексте
    public func draw(in context: CGContext, size target: CGSize) {
        var target = target
        
        let ratio = (
            x: target.width / size.width,
            y: target.height / size.height
        )
        
        let rect = (
            document: CGRect(origin: .zero, size: size), ()
        )

        let scale: (x: CGFloat, y: CGFloat)
        
        if target.width <= 0 {
            scale = (ratio.y, ratio.y)
            target.width = size.width * scale.x
        } else if target.height <= 0 {
            scale = (ratio.x, ratio.x)
            target.width = size.width * scale.y
        } else {
            let min = min(ratio.x, ratio.y)
            scale = (min, min)
            target.width = size.width * scale.x
            target.height = size.height * scale.y
        }

        let transform = (
            scale: CGAffineTransform(scaleX: scale.x, y: scale.y),
            aspect: CGAffineTransform(
                translationX: (target.width / scale.x - rect.document.width) / 2,
                y: (target.height / scale.y - rect.document.height) / 2
            )
        )
        
        context.translateBy(x: 0, y: target.height)
        context.scaleBy(x: 1, y: -1)
        context.concatenate(transform.scale)
        context.concatenate(transform.aspect)
        
        CGContextDrawSVGDocument(context, document)
    }
}

extension Data {
    private static let svgTagEnd = "</svg>"
    
    /// Данные в формате svg или нет
    public var isSVGFormat: Bool {
        guard let endTagData = Data.svgTagEnd.data(using: .utf8) else {
            return false
        }
        
        let nsRange = NSRange(location: count - Swift.min(100, count), length: Swift.min(100, count))
        let range = Range(nsRange)
        return self.range(of: endTagData, options: .backwards, in: range) != nil
    }
}
