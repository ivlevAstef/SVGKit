//
//  DOM.Filter.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 16/8/22.
//  Copyright 2022 Simon Whitty
//

extension DOM {
    
    final class Filter: Element {
        var id: String
        
        var effects: [Effect]
        
        init(id: String) {
            self.id = id
            self.effects = []
        }
        
        enum Effect: Equatable {
            case gaussianBlur(stdDeviation: DOM.Float)
        }
    }
}
