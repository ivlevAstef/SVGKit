//
//  DOM.Text.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

// swiftlint:disable all

import Foundation

extension DOM {
    
    final class Text: GraphicsElement {
        var x: Coordinate?
        var y: Coordinate?
        var value: String
        
        init(x: Coordinate? = nil, y: Coordinate? = nil, value: String) {
            self.x = x
            self.y = y
            self.value = value
        }
    }
    
    final class Anchor: GraphicsElement, ContainerElement {
        var href: URL?
        var childElements = [GraphicsElement]()
    }
}

// swiftlint:enable all
