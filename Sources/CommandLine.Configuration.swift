//
//  CommandLine.Configuration.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 7/12/18.
//  Copyright 2020 Simon Whitty
//

import Foundation

// swiftlint:disable all

extension CommandLine {
    
    struct Configuration {
        var input: URL
        var inputUltralight: URL?
        var inputBlack: URL?
        var output: URL
        var format: Format
        var size: Size
        var api: API?
        var insets: Insets
        var insetsUltralight: Insets?
        var insetsBlack: Insets?
        var scale: Scale
        var options: SVG.Options
        var precision: Int?
    }
    
    enum Format: String {
        case jpeg
        case pdf
        case png
        case swift
        case sfsymbol
    }
    
    enum API: String {
        case appkit
        case uikit
    }
    
    enum Size: Equatable {
        case `default`
        case custom(width: Int, height: Int)
    }
    
    enum Scale: Equatable {
        case `default`
        case retina
        case superRetina
    }
    
    struct Insets: Equatable {
        var top: Double?
        var left: Double?
        var bottom: Double?
        var right: Double?
        
        init(top: Double? = nil, left: Double? = nil, bottom: Double? = nil, right: Double? = nil) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }
        
        var isEmpty: Bool {
            top == nil && left == nil && bottom == nil && right == nil
        }
    }
    
    static func parseConfiguration(from args: [String], baseDirectory: URL) throws -> Configuration {
        guard args.count > 2 else {
            throw Error.invalid
        }
        
        let source = try parseFileURL(file: args[1], within: baseDirectory)
        let modifiers = try parseModifiers(from: Array(args.dropFirst(2)))
        guard
            let formatString = modifiers[.format],
            let formatString,
            let format = Format(rawValue: formatString) else {
                throw Error.invalid
            }
        
        let size = try parseSize(from: modifiers[.size])
        let scale = try parseScale(from: modifiers[.scale])
        let precision = try parsePrecision(from: modifiers[.precision])
        let insets = try parseInsets(from: modifiers[.insets])
        let api = try parseAPI(from: modifiers[.api])
        let ultralight = try parseFileURL(file: modifiers[.ultralight], within: baseDirectory)
        let ultralightInsets = try parseInsets(from: modifiers[.ultralightInsets])
        let black = try parseFileURL(file: modifiers[.black], within: baseDirectory)
        let blackInsets = try parseInsets(from: modifiers[.blackInsets])
        let output = try parseFileURL(file: modifiers[.output], within: baseDirectory)
        
        let options = try parseOptions(from: modifiers)
        let result = source.newURL(for: format, scale: scale)
        return Configuration(input: source,
                             inputUltralight: ultralight,
                             inputBlack: black,
                             output: output ?? result,
                             format: format,
                             size: size,
                             api: api,
                             insets: insets,
                             insetsUltralight: ultralightInsets,
                             insetsBlack: blackInsets,
                             scale: scale,
                             options: options,
                             precision: precision)
    }
    
    static func parseFileURL(file: String, within directory: URL) throws -> URL {
        guard #available(macOS 10.11, *) else {
            throw Error.invalid
        }
        
        return URL(fileURLWithPath: file, relativeTo: directory).standardizedFileURL
    }
    
    static func parseFileURL(file: String??, within directory: URL) throws -> URL? {
        guard let file,
              let file else {
            return nil
        }
        return try parseFileURL(file: file, within: directory)
    }
    
    static func parseScale(from value: String??) throws -> Scale {
        guard let value,
              let value else {
            return .default
        }
        
        guard let scale = Scale(value) else {
            throw Error.invalid
        }
        return scale
    }
    
    static func parsePrecision(from value: String??) throws -> Int? {
        guard let value,
              let value else {
                  return nil
              }
        
        guard let precision = Int(value) else {
            throw Error.invalid
        }
        return precision
    }
    
    static func parseSize(from value: String??) throws -> Size {
        guard let value,
              let value else {
                  return .default
              }
        
        let scanner = Scanner(string: value)
        var width: Int32 = 0
        var height: Int32 = 0
        guard
            scanner.scanInt32(&width),
            scanner.scanString("x", into: nil),
            scanner.scanInt32(&height),
            width > 0, height > 0 else {
                throw Error.invalid
            }
        
        return .custom(width: Int(width), height: Int(height))
    }
    
    static func parseAPI(from value: String??) throws -> API? {
        guard let value,
              let value else {
                  return nil
              }
        
        guard let api = API(rawValue: value) else {
            throw Error.invalid
        }
        return api
    }
    
    static func parseInsets(from value: String??) throws -> Insets {
        guard let value,
              let value,
              value != "auto" else {
                  return Insets()
              }
        
        var scanner = XMLParser.Scanner(text: value)
        let top = try scanner.scanInset()
        _ = try scanner.scanString(",")
        let left = try scanner.scanInset()
        _ = try scanner.scanString(",")
        let bottom = try scanner.scanInset()
        _ = try scanner.scanString(",")
        let right = try  scanner.scanInset()
        return Insets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
    
    static func parseOptions(from modifiers: [CommandLine.Modifier: String?]) throws -> SVG.Options {
        var options: SVG.Options = .default
        
        if modifiers.keys.contains(.hideUnsupportedFilters) {
            options.insert(.hideUnsupportedFilters)
        }
        
        return options
    }
}

private extension XMLParser.Scanner {
    
    mutating func scanInset() throws -> Double? {
        guard !scanStringIfPossible("auto") else {
            return nil
        }
        return try scanDouble()
    }
}

extension SVG.Options {
    static let disableTransparencyLayers = Self(rawValue: 1 << 8)
    static let commandLine = Self(rawValue: 1 << 9)
}

extension URL {
    
    var lastPathComponentName: String {
        let filename = lastPathComponent
        let extensionOffset = pathExtension.isEmpty ? 0 : -pathExtension.count - 1
        let index = filename.index(filename.endIndex, offsetBy: extensionOffset)
        return String(filename[..<index])
    }
    
    func newURL(for format: CommandLine.Format, scale: CommandLine.Scale) -> URL {
        let suffix = Self.lastPathComponentSuffix(format: format, scale: scale)
        let newfilename = "\(lastPathComponentName)\(suffix).\(format.pathExtension)"
        return deletingLastPathComponent()
            .appendingPathComponent(newfilename)
            .standardizedFileURL
    }
    
    static func lastPathComponentSuffix(format: CommandLine.Format, scale: CommandLine.Scale) -> String {
        switch (format, scale) {
        case (.sfsymbol, _):
            return "-symbol"
        case (.png, .retina):
            return "@2x"
        case (.png, .superRetina):
            return "@3x"
        default:
            return ""
        }
    }
}

private extension CommandLine.Format {
    
    var pathExtension: String {
        switch self {
        case .jpeg:
            return "jpg"
        case .pdf:
            return "pdf"
        case .png:
            return "png"
        case .swift:
            return "swift"
        case .sfsymbol:
            return "svg"
        }
    }
}

private extension CommandLine.Scale {
    
    init?(_ value: String) {
        switch value {
        case "1x":
            self = .default
        case "2x":
            self = .retina
        case "3x":
            self = .superRetina
        default:
            return nil
        }
    }
}

// swiftlint:enable all
