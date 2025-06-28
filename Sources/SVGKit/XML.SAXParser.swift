//
//  XML.SAXParser.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 28/1/17.
//  Copyright 2020 Simon Whitty
//

// swiftlint:disable all

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

extension XML {
    
    final class SAXParser: NSObject, XMLParserDelegate {
        
#if canImport(FoundationXML)
        typealias FoundationXMLParser = FoundationXML.XMLParser
#else
        typealias FoundationXMLParser = Foundation.XMLParser
#endif
        
        private let parser: FoundationXMLParser
        private let namespaceURI = "http://www.w3.org/2000/svg"
        
        private var rootNode: Element?
        private var elements: [Element]
        
        private var currentElement: Element {
            return elements.last!
        }
        
        private init(data: Data) {
            self.parser = FoundationXMLParser(data: data)
            elements = [Element]()
            super.init()
            
            self.parser.delegate = self
            self.parser.shouldProcessNamespaces = true
        }
        
        static func parse(data: Data) throws -> Element {
            let parser = SAXParser(data: data)
            
            guard
                parser.parser.parse(),
                
                    let rootNode = parser.rootNode else {
                        throw XMLParser.Error.invalidDocument(error: parser.parser.parserError,
                                                              element: parser.elements.last?.name,
                                                              line: parser.parser.lineNumber,
                                                              column: parser.parser.columnNumber)
                    }
            
            return rootNode
        }
        
        static func parse(contentsOf url: URL) throws -> Element {
            let data = try Data(contentsOf: url)
            return try parse(data: data)
        }
        
        func parser(
            _ parser: FoundationXMLParser,
            didStartElement elementName: String,
            namespaceURI: String?,
            qualifiedName _: String?,
            attributes attributeDict: [String: String] = [:]
        ) {
            guard
                self.parser === parser,
                namespaceURI == self.namespaceURI else {
                    return
                }
            
            let element = Element(name: elementName, attributes: attributeDict)
            element.parsedLocation = (line: parser.lineNumber, column: parser.columnNumber)
            
            elements.last?.children.append(element)
            elements.append(element)
            
            if rootNode == nil {
                rootNode = element
            }
        }
        
        func parser(
            _ parser: FoundationXMLParser,
            didEndElement elementName: String,
            namespaceURI: String?,
            qualifiedName _: String?
        ) {
            guard
                namespaceURI == self.namespaceURI,
                currentElement.name == elementName else {
                    return
                }
            
            elements.removeLast()
        }
        
        func parser(_ parser: FoundationXMLParser, foundCharacters string: String) {
            guard let element = elements.last else { return }
            let text = element.innerText.map { $0.appending(string) }
            element.innerText = text ?? string
        }
    }
}

// swiftlint:enable all
