//
//  Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 24/5/17.
//  Copyright 2020 Simon Whitty
//

import Foundation

// swiftlint:disable all

#if canImport(CoreGraphics)
import CoreGraphics

@objc(SVGImage)
final class SVG: NSObject {
    let size: CGSize
    
    // An Image is simply an array of CoreGraphics draw commands
    // see: Renderer.swift
    let commands: [RendererCommand<CGTypes>]
    
    init(dom: DOM.SVG, options: Options) {
        self.size = CGSize(width: dom.width, height: dom.height)
        
        // To create the draw commands;
        // - XML is parsed into DOM.SVG
        // - DOM.SVG is converted into a LayerTree
        // - LayerTree is converted into RenderCommands
        // - RenderCommands are performed by Renderer (drawn to CGContext)
        let layer = LayerTree.Builder(svg: dom).makeLayer()
        let generator = LayerTree.CommandGenerator(provider: CGProvider(),
                                                   size: LayerTree.Size(dom.width, dom.height),
                                                   options: options)
        
        let optimizer = LayerTree.CommandOptimizer<CGTypes>()
        commands = optimizer.optimizeCommands(
            generator.renderCommands(for: layer)
        )
    }
    
    struct Options: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let hideUnsupportedFilters = Options(rawValue: 1 << 0)
        
        public static let `default`: Options = []
    }
}

#else

final class SVG: NSObject {
    let size: CGSize
    
    init(dom: DOM.SVG, options: Options) {
        size = CGSize(width: dom.width, height: dom.height)
    }
    
    struct Options: OptionSet {
        let rawValue: Int
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let hideUnsupportedFilters = Options(rawValue: 1 << 0)
        
        static let `default`: Options = []
    }
}

extension SVG {
    
    func pngData(size: CGSize? = nil, scale: CGFloat = 1) -> Data? {
        return nil
    }
    
    func jpegData(size: CGSize? = nil, scale: CGFloat = 1, compressionQuality quality: CGFloat = 1) -> Data? {
        return nil
    }
    
    func pdfData(size: CGSize? = nil) -> Data? {
        return nil
    }
    
    static func pdfData(fileURL url: URL, size: CGSize? = nil) throws -> Data {
        throw DOM.Error.missing("not implemented")
    }
}
#endif

extension DOM.SVG {
    
    static func parse(fileURL url: URL, options: XMLParser.Options = .skipInvalidElements) throws -> DOM.SVG {
        let element = try XML.SAXParser.parse(contentsOf: url)
        let parser = XMLParser(options: options, filename: url.lastPathComponent)
        return try parser.parseSVG(element)
    }
    
    static func parse(data: Data, options: XMLParser.Options = .skipInvalidElements) throws -> DOM.SVG {
        let element = try XML.SAXParser.parse(data: data)
        let parser = XMLParser(options: options)
        return try parser.parseSVG(element)
    }
}

extension SVG {
    
    convenience init?(fileURL url: URL, options: SVG.Options = .default) {
        do {
            let svg = try DOM.SVG.parse(fileURL: url)
            self.init(dom: svg, options: options)
        } catch {
            XMLParser.logParsingError(for: error, filename: url.lastPathComponent, parsing: nil)
            return nil
        }
    }
    
    convenience init?(named name: String, in bundle: Bundle = Bundle.main, options: SVG.Options = .default) {
        guard let url = bundle.url(forResource: name, withExtension: nil) else {
            return nil
        }
        
        self.init(fileURL: url, options: options)
    }
    
    convenience init?(data: Data, options: SVG.Options = .default) {
        guard let svg = try? DOM.SVG.parse(data: data) else {
            return nil
        }
        
        self.init(dom: svg, options: options)
    }
    
    
    struct Insets: Equatable {
        var top: CGFloat
        var left: CGFloat
        var bottom: CGFloat
        var right: CGFloat
        
        static let zero = Insets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// swiftlint:enable all
