//
//  LayerTree.Pattern.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 27/3/19.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

extension LayerTree {
    
    final class Pattern: Equatable {
        
        var frame: LayerTree.Rect
        var contents: [LayerTree.Layer.Contents]
        
        init(frame: LayerTree.Rect) {
            self.frame = frame
            self.contents = []
        }
        
        static func == (lhs: LayerTree.Pattern, rhs: LayerTree.Pattern) -> Bool {
            return lhs.contents == rhs.contents
        }
    }
}
