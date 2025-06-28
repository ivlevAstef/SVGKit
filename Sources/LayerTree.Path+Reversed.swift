//
//  LayerTreet.Path+Reversed.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 21/8/22.
//  Copyright 2022 Simon Whitty
//

extension LayerTree.Path {
    
    var reversed: LayerTree.Path {
        var reversed = segments
            .reversed()
            .paired(with: .nextSkippingLast)
            .compactMap { segment, next in
                segment.reversing(to: next.location)
            }
        
        if let point = segments.lastLocation {
            reversed.insert(.move(to: point), at: 0)
        }
        
        while reversed.last?.isMove == true {
            reversed.removeLast()
        }
        
        if segments.last?.isClose == true {
            reversed.append(.close)
        }
        
        return .init(reversed)
    }
    
    func makeNonZero() -> LayerTree.Path {
        let paths = makeNodes().flatMap { $0.windPaths() }
        return LayerTree.Path(paths.flatMap(\.segments))
    }
}

private extension LayerTree.Path {
    
    func makeNodes() -> [SubPathNode] {
        var nodes = [SubPathNode]()
        
        for p in subpaths {
            let node = SubPathNode(p)
            if let idx = nodes.firstIndex(where: { $0.bounds.contains(point: node.bounds.center) }) {
                nodes[idx].append(node)
            } else {
                nodes.append(node)
            }
        }
        return nodes
    }
}

private struct SubPathNode {
    let path: LayerTree.Path
    let bounds: LayerTree.Rect
    let direction: LayerTree.Path.Direction
    var children: [SubPathNode] = []
    
    init(_ path: LayerTree.Path) {
        self.path = path
        self.bounds = path.bounds
        self.direction = path.segments.direction
    }
    
    mutating func append(_ node: SubPathNode) {
        if let idx = children.firstIndex(where: { $0.bounds.contains(point: node.bounds.center) }) {
            children[idx].append(node)
        } else {
            children.append(node)
        }
    }
    
    func windPaths() -> [LayerTree.Path] {
        windPaths(direction)
    }
    
    func windPaths(_ direction: LayerTree.Path.Direction) -> [LayerTree.Path] {
        var paths = [LayerTree.Path]()
        
        if self.direction == direction {
            paths.append(path)
        } else {
            paths.append(path.reversed)
        }
        
        paths += children.flatMap { $0.windPaths(direction.opposite) }
        return paths
    }
}

private extension Array where Element == LayerTree.Path.Segment {
    
    var lastLocation: LayerTree.Point? {
        for segment in reversed() {
            if let location = segment.location {
                return location
            }
        }
        return nil
    }
}

private extension LayerTree.Path.Segment {
    
    func reversing(to point: LayerTree.Point?) -> Self? {
        guard let point else {
            return nil
        }
        switch self {
        case .move:
            return .move(to: point)
        case .line:
            return .line(to: point)
        case let .cubic(to: _, control1: control1, control2: control2):
            return .cubic(to: point, control1: control2, control2: control1)
        case .close:
            return nil
        }
    }
}
