//
//  Parser.XML.Attributes.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

import Foundation

extension XMLParser {
    // Storage for merging XMLElement attibutes and style properties;
    // style properties have precedence over element attibutes
    // <line stroke="none" fill="red" style="stroke: 2" />
    // attributes["stoke"] == "2"
    // attributes["fill"] == "red"
    final class Attributes: AttributeParser {
        
        let parser: AttributeValueParser
        let options: XMLParser.Options
        
        let element: [String: String]
        let style: [String: String]
        
        // swiftlint:disable all
        init(
            parser: AttributeValueParser,
            options: XMLParser.Options = [],
            element: [String: String],
            style: [String: String]
        ) {
            self.parser = parser
            self.options = options
            self.element = element
            self.style = style
        }
        // swiftlint:enable all
        
        func parse<T>(_ key: String, _ exp: (String) throws -> T) throws -> T {
            do {
                return try parse(style[key], with: exp, for: key)
            } catch XMLParser.Error.missingAttribute(_) {
                return try parse(element[key], with: exp, for: key)
            } catch let error {
                guard options.contains(.skipInvalidAttributes) else { throw error }
            }
            return try parse(element[key], with: exp, for: key)
        }
        
        func parse<T>(_ value: String?, with expression: (String) throws -> T, for key: String) throws -> T {
            guard let value else { throw XMLParser.Error.missingAttribute(name: key) }
            guard let result = try? expression(value) else {
                throw XMLParser.Error.invalidAttribute(name: key, value: value)
            }
            return result
        }
    }
}

extension XMLParser {
    
    struct ValueParser: AttributeValueParser {
        
        func parseFloat(_ value: String) throws -> DOM.Float {
            var scanner = XMLParser.Scanner(text: value)
            return try scanner.scanFloat()
        }
        
        func parseFloats(_ value: String) throws -> [DOM.Float] {
            var array = [DOM.Float]()
            var scanner = XMLParser.Scanner(text: value)
            
            while !scanner.isEOF {
                let vx = try scanner.scanFloat()
                scanner.scanStringIfPossible(",")
                array.append(vx)
            }
            
            return array
        }
        
        
        func parsePercentage(_ value: String) throws -> DOM.Float {
            var scanner = XMLParser.Scanner(text: value)
            guard let pc = try? scanner.scanPercentage() else {
                // try a value between 0.0, 1.0
                return try scanner.scanPercentageFloat()
            }
            return pc
        }
        
        func parseCoordinate(_ value: String) throws -> DOM.Coordinate {
            var scanner = XMLParser.Scanner(text: value)
            return try scanner.scanCoordinate()
        }
        
        func parseLength(_ value: String) throws -> DOM.Length {
            var scanner = XMLParser.Scanner(text: value)
            return try scanner.scanLength()
        }
        
        func parseBool(_ value: String) throws -> DOM.Bool {
            var scanner = XMLParser.Scanner(text: value)
            return try scanner.scanBool()
        }
        
        func parseFill(_ value: String) throws -> DOM.Fill {
            return try XMLParser().parseFill(value)
        }
        
        func parseUrl(_ value: String) throws -> DOM.URL {
            guard let url = URL(maybeData: value) else { throw XMLParser.Error.invalid }
            return url
            
        }
        func parseUrlSelector(_ value: String) throws -> DOM.URL {
            var scanner = XMLParser.Scanner(text: value)
            
            try scanner.scanString("url(")
            let urlText = try scanner.scanString(upTo: ")")
            _ = try? scanner.scanString(")")
            
            let url = urlText.trimmingCharacters(in: .whitespaces)
            
            guard !url.isEmpty, scanner.isEOF else {
                throw XMLParser.Error.invalid
            }
            
            return try parseUrl(url)
        }
        
        func parsePoints(_ value: String) throws -> [DOM.Point] {
            var points = [DOM.Point]()
            var scanner = XMLParser.Scanner(text: value)
            let delimeter = CharacterSet(charactersIn: ",;")
            
            while !scanner.isEOF {
                let px = try? scanner.scanCoordinate()
                _ = try? scanner.scanCharacter(matchingAny: delimeter)
                let py = try? scanner.scanCoordinate()
                _ = try? scanner.scanCharacter(matchingAny: delimeter)
                
                guard let x = px,
                      let y = py else { throw XMLParser.Error.invalid }
                
                points.append(DOM.Point(x, y))
            }
            
            return points
        }
        
        func parseRaw<T: RawRepresentable>(_ value: String) throws -> T where T.RawValue == String {
            guard let obj = T(rawValue: value.trimmingCharacters(in: .whitespaces)) else {
                throw XMLParser.Error.invalid
            }
            return obj
        }
    }
    
}
