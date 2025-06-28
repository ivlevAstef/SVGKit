//
//  DOM.PresentationAttributes.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 19/8/22.
//  Copyright 2022 Simon Whitty
//

// swiftlint:disable all

import Foundation

extension DOM {
    
    // PresentationAttributes cascade;
    // element.attributes --> .element() --> .class() ---> .id() ---> element.style ---> layerTree.state
    
    struct PresentationAttributes {
        var opacity: DOM.Float?
        var display: DOM.DisplayMode?
        var color: DOM.Color?
        
        var stroke: DOM.Fill?
        var strokeWidth: DOM.Float?
        var strokeOpacity: DOM.Float?
        var strokeLineCap: DOM.LineCap?
        var strokeLineJoin: DOM.LineJoin?
        var strokeDashArray: [DOM.Float]?
        
        var fill: DOM.Fill?
        var fillOpacity: DOM.Float?
        var fillRule: DOM.FillRule?
        
        var fontFamily: String?
        var fontSize: Float?
        var textAnchor: TextAnchor?
        
        var transform: [DOM.Transform]?
        var clipPath: DOM.URL?
        var clipRule: DOM.FillRule?
        var mask: DOM.URL?
        var filter: DOM.URL?
    }
    
    static func presentationAttributes(for element: DOM.GraphicsElement,
                                       styles: [StyleSheet]) -> PresentationAttributes {
        var attributes = element.attributes
        
        for selector in makeSelectors(for: element) {
            let new = makeAttributes(for: selector, styles: styles)
            attributes = attributes.applyingAttributes(new)
        }
        
        attributes = attributes.applyingAttributes(element.style)
        return attributes
    }
    
    static func makeSelectors(for element: DOM.GraphicsElement) -> [StyleSheet.Selector] {
        var selectors = [StyleSheet.Selector]()
        
        if let elementName = element.elementName {
            selectors.append(.element(elementName))
        }
        
        if let classes = element.class?.split(separator: " ") {
            selectors.append(contentsOf: classes
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .map(StyleSheet.Selector.class)
            )
        }
        
        if let id = element.id {
            selectors.append(.id(id.trimmingCharacters(in: .whitespacesAndNewlines)))
        }
        
        return selectors
    }
    
    static func makeAttributes(for selector: StyleSheet.Selector, styles: [StyleSheet]) -> PresentationAttributes {
        var attributes = PresentationAttributes()
        
        for sheet in styles {
            if let att = sheet.attributes[selector] {
                attributes = attributes.applyingAttributes(att)
            }
        }
        
        return attributes
    }
}

extension DOM.PresentationAttributes {
    
    func applyingAttributes(_ att: Self) -> Self {
        var merged = DOM.PresentationAttributes()
        
        merged.opacity = att.opacity ?? opacity
        merged.display = att.display ?? display
        merged.color = att.color ?? color
        
        merged.stroke = att.stroke ?? stroke
        merged.strokeWidth = att.strokeWidth ?? strokeWidth
        merged.strokeOpacity = att.strokeOpacity ?? strokeOpacity
        merged.strokeLineCap = att.strokeLineCap ?? strokeLineCap
        merged.strokeLineJoin = att.strokeLineJoin ?? strokeLineJoin
        merged.strokeDashArray = att.strokeDashArray ?? strokeDashArray
        
        merged.fill = att.fill ?? fill
        merged.fillOpacity = att.fillOpacity ?? fillOpacity
        merged.fillRule = att.fillRule ?? fillRule
        
        merged.fontFamily = att.fontFamily ?? fontFamily
        merged.fontSize = att.fontSize ?? fontSize
        merged.textAnchor = att.textAnchor ?? textAnchor
        
        merged.transform = att.transform ?? transform
        merged.clipPath = att.clipPath ?? clipPath
        merged.clipRule = att.clipRule ?? clipRule
        merged.mask = att.mask ?? mask
        merged.filter = att.filter ?? filter
        
        return merged
    }
}

extension DOM.GraphicsElement {
    
    var elementName: String? {
        switch self {
        case is DOM.Line:
            return "line"
        case is DOM.Circle:
            return "circle"
        case is DOM.Ellipse:
            return "ellipse"
        case is DOM.Rect:
            return "rect"
        case is DOM.Polyline:
            return "polyline"
        case is DOM.Polygon:
            return "polygon"
        case is DOM.Path:
            return "path"
        case is DOM.Text:
            return "text"
        case is DOM.Image:
            return "image"
        case is DOM.Group:
            return "g"
        case is DOM.Anchor:
            return "a"
        case is DOM.SVG:
            return "svg"
        default:
            return nil
        }
    }
}

// swiftlint:enable all
