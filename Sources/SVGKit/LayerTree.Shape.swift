//
//  LayerTree.Shape.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 3/6/17.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

extension LayerTree {
    
    enum Shape: Hashable {
        case line(between: [Point])
        case rect(within: Rect, radii: Size)
        case ellipse(within: Rect)
        case polygon(between: [Point])
        case path(Path)
    }
}

extension LayerTree.Shape {
    
    var path: LayerTree.Path {
        switch self {
        case let .line(between: points):
            return .makeLine(between: points)
        case let .rect(within: rect, radii: radii):
            return .makeRect(within: rect, radii: radii)
        case let .ellipse(within: rect):
            return .makeEllipse(within: rect)
        case let .polygon(between: points):
            return .makePolygon(between: points)
        case let .path(path):
            return path
        }
    }
}

extension LayerTree.Path {
    
    static func makeLine(between points: [LayerTree.Point]) -> LayerTree.Path {
        guard let first = points.first else {
            return .init()
        }
        let segments = [LayerTree.Path.Segment.move(to: first)] +
        points.dropFirst().map(LayerTree.Path.Segment.line)
        
        return .init(segments)
    }
    
    static func makeRect(
        within rect: LayerTree.Rect,
        radii: LayerTree.Size
    ) -> LayerTree.Path {
        if radii == .zero {
            let path = LayerTree.Path()
            path.move(to: .init(rect.maxX, rect.minY))
            path.line(to: .init(rect.maxX, rect.maxY))
            path.line(to: .init(rect.minX, rect.maxY))
            path.line(to: .init(rect.minX, rect.minY))
            path.close()
            return path
        } else {
            let path = LayerTree.Path()
            path.move(to: .init(rect.maxX, rect.midY))
            path.line(to: .init(rect.maxX, rect.maxY - radii.height))
            path.arc(to: .init(rect.maxX - radii.width, rect.maxY), radii: radii)
            path.line(to: .init(rect.minX + radii.width, rect.maxY))
            path.arc(to: .init(rect.minX, rect.maxY - radii.height), radii: radii)
            path.line(to: .init(rect.minX, rect.minY + radii.height))
            path.arc(to: .init(rect.minX + radii.width, rect.minY), radii: radii)
            path.line(to: .init(rect.maxX - radii.width, rect.minY))
            path.arc(to: .init(rect.maxX, rect.minY + radii.height), radii: radii)
            path.close()
            return path
        }
    }
    
    static func makeEllipse(within rect: LayerTree.Rect) -> LayerTree.Path {
        let radii = LayerTree.Size(rect.width / 2, rect.height / 2)
        let path = LayerTree.Path()
        path.move(to: .init(rect.minX, rect.midY))
        path.arc(to: .init(rect.maxX, rect.midY), large: false, radii: radii)
        path.arc(to: .init(rect.minX, rect.midY), large: true, radii: radii)
        path.close()
        return path
    }
    
    static func makePolygon(between points: [LayerTree.Point]) -> LayerTree.Path {
        let path = makeLine(between: points)
        if !path.segments.isEmpty {
            path.segments.append(.close)
        }
        return path
    }
}

private extension LayerTree.Path {
    // swiftlint:disable all
    
    func arc(to point: LayerTree.Point, large: Bool = false, radii: LayerTree.Size) {
        guard let location else {
            return
        }
        segments.append(contentsOf: LayerTree.Builder.makeArc(
            from: location,
            to: point,
            large: large,
            sweep: true,
            rx: radii.width,
            ry: radii.height,
            rotation: 0
        ))
    }
    
    // swiftlint:enable all
}
