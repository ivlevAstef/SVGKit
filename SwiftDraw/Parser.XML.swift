//
//  Parser.XML.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

struct XMLParser {
    enum Error: Swift.Error {
        case invalid
        case missingAttribute(name: String)
        case invalidAttribute(name: String, value: Any)
        case invalidElement(name: String, error: Swift.Error, line: Int?, column: Int?)
        case invalidDocument(error: Swift.Error?, element: String?, line: Int, column: Int)
    }
    
    struct Options: OptionSet {
        let rawValue: Int
        
        static let skipInvalidAttributes = Options(rawValue: 1)
        static let skipInvalidElements = Options(rawValue: 2)
    }
    
    var options: Options = []
    var filename: String?
}

protocol AttributeValueParser {
    func parseFloat(_ value: String) throws -> DOM.Float
    func parseFloats(_ value: String) throws -> [DOM.Float]
    func parsePercentage(_ value: String) throws -> DOM.Float
    func parseCoordinate(_ value: String) throws -> DOM.Coordinate
    func parseLength(_ value: String) throws -> DOM.Length
    func parseBool(_ value: String) throws -> DOM.Bool
    func parseFill(_ value: String) throws -> DOM.Fill
    func parseUrl(_ value: String) throws -> DOM.URL
    func parseUrlSelector(_ value: String) throws -> DOM.URL
    func parsePoints(_ value: String) throws -> [DOM.Point]
    
    func parseRaw<T: RawRepresentable>(_ value: String) throws -> T where T.RawValue == String
}

protocol AttributeParser {
    var parser: AttributeValueParser { get }
    var options: XMLParser.Options { get }
    
    // either parse and return T or
    // throw Error.missingAttribute when key cannot resolve to a value
    // throw Error.invalidAttribute when value cannot be parsed into T
    func parse<T>(_ key: String, _ exp: (String) throws -> T) throws -> T
}

extension AttributeParser {
    
    func parseString(_ key: String) throws -> String {
        return try parse(key) { $0 }
    }
    
    func parseFloat(_ key: String) throws -> DOM.Float {
        return try parse(key) { return try parser.parseFloat($0) }
    }
    
    func parseFloats(_ key: String) throws -> [DOM.Float] {
        return try parse(key) { return try parser.parseFloats($0) }
    }
    
    func parsePercentage(_ key: String) throws -> DOM.Float {
        return try parse(key) { return try parser.parsePercentage($0) }
    }
    
    func parseCoordinate(_ key: String) throws -> DOM.Coordinate {
        return try parse(key) { return try parser.parseCoordinate($0) }
    }
    
    func parseLength(_ key: String) throws -> DOM.Length {
        return try parse(key) { return try parser.parseLength($0) }
    }
    
    func parseBool(_ key: String) throws -> DOM.Bool {
        return try parse(key) { return try parser.parseBool($0) }
    }
    
    func parseFill(_ key: String) throws -> DOM.Fill {
        return try parse(key) { return try parser.parseFill($0) }
    }
    
    func parseColor(_ key: String) throws -> DOM.Color {
        return try parseFill(key).getColor()
    }
    
    func parseUrl(_ key: String) throws -> DOM.URL {
        return try parse(key) { return try parser.parseUrl($0) }
    }
    
    func parseUrlSelector(_ key: String) throws -> DOM.URL {
        return try parse(key) { return try parser.parseUrlSelector($0) }
    }
    
    func parsePoints(_ key: String) throws -> [DOM.Point] {
        return try parse(key) { return try parser.parsePoints($0) }
    }
    
    func parseRaw<T: RawRepresentable>(_ key: String) throws -> T where T.RawValue == String {
        return try parse(key) { return try parser.parseRaw($0) }
    }
}

extension AttributeParser {
    
    typealias Options = XMLParser.Options
    
    func parse<T>(_ key: String, exp: (String) throws -> T) throws -> T? {
        do {
            return try parse(key, exp)
        } catch XMLParser.Error.missingAttribute(_) {
            return nil
        } catch let error {
            guard options.contains(.skipInvalidAttributes) else { throw error }
        }
        return nil
    }
    
    func parseString(_ key: String) throws -> String? {
        return try parse(key) { $0 }
    }
    
    func parseFloat(_ key: String) throws -> DOM.Float? {
        return try parse(key) { return try parser.parseFloat($0) }
    }
    
    func parseFloats(_ key: String) throws -> [DOM.Float]? {
        return try parse(key) { return try parser.parseFloats($0) }
    }
    
    func parsePercentage(_ key: String) throws -> DOM.Float? {
        return try parse(key) { return try parser.parsePercentage($0) }
    }
    
    func parseCoordinate(_ key: String) throws -> DOM.Coordinate? {
        return try parse(key) { return try parser.parseCoordinate($0) }
    }
    
    func parseLength(_ key: String) throws -> DOM.Length? {
        return try parse(key) { return try parser.parseLength($0) }
    }
    
    func parseBool(_ key: String) throws -> DOM.Bool? {
        return try parse(key) { return try parser.parseBool($0) }
    }
    
    func parseFill(_ key: String) throws -> DOM.Fill? {
        return try parse(key) { return try parser.parseFill($0) }
    }
    
    func parseColor(_ key: String) throws -> DOM.Color? {
        return try parseFill(key)?.getColor()
    }
    
    func parseUrl(_ key: String) throws -> DOM.URL? {
        return try parse(key) { return try parser.parseUrl($0) }
    }
    
    func parseUrlSelector(_ key: String) throws -> DOM.URL? {
        return try parse(key) { return try parser.parseUrlSelector($0) }
    }
    
    func parsePoints(_ key: String) throws -> [DOM.Point]? {
        return try parse(key) { return try parser.parsePoints($0) }
    }
    
    func parseRaw<T: RawRepresentable>(_ key: String) throws -> T? where T.RawValue == String {
        return try parse(key) { return try parser.parseRaw($0) }
    }
}
