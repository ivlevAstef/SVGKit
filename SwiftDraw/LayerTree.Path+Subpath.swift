//
//  LayerTreet.Path+Subpath.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 21/8/22.
//  Copyright 2022 Simon Whitty
//

extension LayerTree.Path {
    
    var subpaths: [LayerTree.Path] {
        var builder = SubpathBuilder()
        return builder.makeSubpaths(for: self)
    }
}

extension LayerTree.Path {
    
    struct SubpathBuilder {
        typealias Point = LayerTree.Point
        
        var start: Point?
        var location: Point = .zero
        
        var subpaths = [LayerTree.Path]()
        var current = [LayerTree.Path.Segment]()
        
        mutating func makeSubpaths(for path: LayerTree.Path) -> [LayerTree.Path] {
            subpaths = []
            current = []
            start = nil
            for s in path.segments {
                appendSegment(s)
            }
            
            if current.contains(where: \.isEdge) {
                subpaths.append(.init(current))
            }
            
            return subpaths
        }
        
        mutating func appendSegment(_ segment: LayerTree.Path.Segment) {
            switch segment {
            case let .move(to: p):
                if let idx = current.indices.last, current[idx].isMove {
                    current[idx] = segment
                } else {
                    current.append(segment)
                }
                location = p
                start = nil
            case let .line(to: p):
                current.append(segment)
                if start == nil {
                    start = location
                }
                location = p
            case let .cubic(to: p, control1: _, control2: _):
                current.append(segment)
                if start == nil {
                    start = location
                }
                location = p
            case .close:
                current.append(segment)
                subpaths.append(.init(current))
                current = []
                if let start {
                    location = start
                    current.append(.move(to: start))
                }
                start = nil
            }
        }
    }
}

private extension LayerTree.Path.Segment {
    
    var isEdge: Bool {
        switch self {
        case .line, .cubic:
            return true
        case .move, .close:
            return false
        }
    }
}
