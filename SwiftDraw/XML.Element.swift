//
//  XML.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//


enum XML { /* namespace */ }

extension XML {
    final class Element {
        
        let name: String
        var attributes: [String: String]
        var children = [Element]()
        var innerText: String?
        
        var parsedLocation: (line: Int, column: Int)?
        
        init(name: String, attributes: [String: String] = [:]) {
            self.name = name
            self.attributes = attributes
            self.innerText = nil
        }
    }
}
