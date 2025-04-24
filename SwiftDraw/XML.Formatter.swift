//
//  XML.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//


import Foundation

extension XML {
    struct Formatter {
        
        var spaces: Int = 4
        
        func encodeRootElement(_ element: XML.Element) -> String {
            """
            <?xml version="1.0" encoding="UTF-8"?>
            \(encodeElement(element))
            """
        }
        
        func encodeElement(_ element: XML.Element, indent: Int = 0) -> String {
            let start = encodeElementStart(element, indent: indent)
            
            if let innerText = element.innerText {
                let end = encodeElementEnd(element, indent: 0)
                return "\(start)\(innerText)\(end)"
            } else if element.children.isEmpty {
                return String(start.dropLast()) + " />"
            } else {
                let end = encodeElementEnd(element, indent: indent)
                var lines = [start]
                for child in element.children {
                    lines.append(encodeElement(child, indent: indent + 1))
                }
                lines.append(end)
                return lines.joined(separator: "\n")
            }
        }
        
        private func encodeElementStart(_ element: XML.Element, indent: Int) -> String {
            let attributes = encodeAttributes(element.attributes)
            
            if attributes.isEmpty {
                return "\(encodeIndent(indent))<\(element.name)>"
            } else {
                return "\(encodeIndent(indent))<\(element.name) \(attributes)>"
            }
        }
        
        private func encodeElementEnd(_ element: XML.Element, indent: Int) -> String {
            "\(encodeIndent(indent))</\(element.name)>"
        }
        
        private func encodeAttributes(_ attributes: [String: String]) -> String {
            var atts = [String]()
            for key in attributes.keys.sorted(by: Self.attributeSort) {
                atts.append("\(key)=\"\(encodeString(attributes[key]!))\"")
            }
            return atts.joined(separator: " ")
        }
        
        private static func attributeSort(lhs: String, rhs: String) -> Bool {
            if lhs == "id" {
                return true
            } else if rhs == "id" {
                return false
            }
            return lhs < rhs
        }
        
        private func encodeString(_ string: String) -> String {
            string
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "\"", with: "&quot;")
            // .replacingOccurrences(of: "\'", with: "&apos;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
        }
        
        private func encodeIndent(_ indent: Int) -> String {
            String(repeating: " ", count: indent * spaces)
        }
    }
}
