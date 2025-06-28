//
//  CommandLine+Process.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 23/8/22.
//  Copyright 2022 Simon Whitty
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// swiftlint:disable missing_docs
// swiftlint:disable multiline_arguments_brackets

extension CommandLine {

    static func processImage(with config: Configuration) throws -> Data {
        guard FileManager.default.fileExists(atPath: config.input.path) else {
            throw Error.fileNotFound
        }
        
        switch config.format {
        case .swift:
            let api = makeTextAPI(for: config.api)
            let code = try CGTextRenderer.render(fileURL: config.input,
                                                 size: config.size.renderSize,
                                                 options: config.options,
                                                 api: api,
                                                 precision: config.precision ?? 2)
            return code.data(using: .utf8)!
        case .sfsymbol:
            let renderer = SFSymbolRenderer(options: config.options,
                                            insets: config.insets,
                                            insetsUltralight: config.insetsUltralight ?? config.insets,
                                            insetsBlack: config.insetsBlack ?? config.insets,
                                            precision: config.precision ?? 3)
            let svg = try renderer.render(regular: config.input,
                                          ultralight: config.inputUltralight,
                                          black: config.inputBlack)
            return svg.data(using: .utf8)!
        case .jpeg, .pdf, .png:
#if canImport(CoreGraphics)
            let options = makeSVGOptions(for: config)
            guard let image = SVG(fileURL: config.input, options: options) else {
                throw Error.invalid
            }
            return try processImage(image, with: config)
#else
            throw Error.unsupported
#endif
            
        }
    }
    
    static func makeSVGOptions(for config: Configuration) -> SVG.Options {
        var options = config.options
        options.insert(.commandLine)
        if config.format == .pdf {
            options.insert(.disableTransparencyLayers)
        }
        return options
    }
    
    static func makeTextAPI(for api: CommandLine.API?) -> CGTextRenderer.API {
        guard let api else {
            return .uiKit
        }
        switch api {
        case .appkit:
            return .appKit
        case .uikit:
            return .uiKit
        }
    }
    
    static func processImage(_ image: SVG, with config: Configuration) throws -> Data {
#if canImport(CoreGraphics)
        switch config.format {
        case .jpeg:
            let insets = try makeImageInsets(for: config.insets)
            return try image.jpegData(size: config.size.cgValue, scale: config.scale.cgValue, insets: insets)
        case .pdf:
            let insets = try makeImageInsets(for: config.insets)
            return try image.pdfData(size: config.size.cgValue, insets: insets)
        case .png:
            let insets = try makeImageInsets(for: config.insets)
            return try image.pngData(size: config.size.cgValue, scale: config.scale.cgValue, insets: insets)
        case .swift, .sfsymbol:
            throw Error.unsupported
        }
#else
        throw Error.unsupported
#endif
    }
    
    static func makeImageInsets(for insets: CommandLine.Insets) throws -> SVG.Insets {
        guard !insets.isEmpty else {
            return .zero
        }
        
        guard insets.top != nil,
              insets.left != nil,
              insets.right != nil,
              insets.bottom != nil else {
                  throw Error.unsupported
              }
        return SVG.Insets(
            top: insets.top!,
            left: insets.left!,
            bottom: insets.bottom!,
            right: insets.right!
        )
    }
}

#if canImport(CoreGraphics)
private extension CommandLine.Scale {
    var cgValue: CGFloat {
        switch self {
        case .default:
            return 1
        case .retina:
            return 2
        case .superRetina:
            return 3
        }
    }
}

private extension CommandLine.Size {
    var cgValue: CGSize? {
        switch self {
        case .default:
            return nil
        case .custom(width: let width, height: let height):
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }
    }
}
#endif

private extension CommandLine.Size {
    var renderSize: CGTextRenderer.Size? {
        switch self {
        case .default:
            return nil
        case .custom(width: let width, height: let height):
            return (width: width, height: height)
        }
    }
}
// swiftlint:enable missing_docs
// swiftlint:enable multiline_arguments_brackets
