//
//  LayerTree.Image.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 3/6/17.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

import Foundation

extension LayerTree {
    enum Image: Equatable {
        case jpeg(data: Data)
        case png(data: Data)
        
        init?(mimeType: String, data: Data) {
            if data.isEmpty {
                return nil
            }
            
            switch mimeType {
            case "image/png":
                self = .png(data: data)
            case "image/jpeg":
                self = .jpeg(data: data)
            case "image/jpg":
                self = .jpeg(data: data)
            default:
                return nil
            }
        }
    }
}
