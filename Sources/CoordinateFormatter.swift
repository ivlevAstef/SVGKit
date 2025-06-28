//
//  CoordinateFormatter.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 31/12/16.
//  Copyright 2020 Simon Whitty
//

import Foundation

struct CoordinateFormatter {
    
    enum Precision {
        case capped(max: Int)
        case maximum
    }
    
    struct Delimeter: RawRepresentable {
        var rawValue: String
        
        static let space = Delimeter(rawValue: " ")
        static let comma = Delimeter(rawValue: ",")
        static let commaSpace = Delimeter(rawValue: ", ")
    }
    
    private let delimeter: Delimeter
    private let precision: Precision
    private let formatter: NumberFormatter
    
    init(delimeter: Delimeter = .space, precision: Precision = .capped(max: 5)) {
        self.delimeter = delimeter
        self.precision = precision
        self.formatter = NumberFormatter()
        self.formatter.locale = .init(identifier: "en_US")
    }
    
    func formatLength(_ length: DOM.Length) -> String {
        return formatValue(Double(length))
    }
    
    func format(_ coordinate: DOM.Coordinate?) -> String? {
        guard let coordinate else {
            return nil
        }
        return formatValue(Double(coordinate))
    }
    
    func format(_ coordinate: Double?) -> String? {
        guard let coordinate else {
            return nil
        }
        return formatValue(coordinate)
    }
    
    func format(_ coordinates: DOM.Coordinate..., precision: Precision? = nil) -> String {
        let precision = precision ?? self.precision
        return coordinates
            .map { formatValue(Double($0), precision: precision) }
            .joined(separator: delimeter.rawValue)
    }
    
    func format(_ coordinates: Double..., precision: Precision? = nil) -> String {
        let precision = precision ?? self.precision
        return coordinates
            .map { formatValue($0, precision: precision) }
            .joined(separator: delimeter.rawValue)
    }
    
    func format(_ flag: Bool) -> String {
        flag ? "1" : "0"
    }
    
    private func formatValue(_ c: Double) -> String {
        formatValue(c, precision: precision)
    }
    
    private func formatValue(_ c: Double, precision: Precision) -> String {
        switch precision {
        case .capped(let max):
            return format(c, capped: max)
        default:
            return String(describing: c)
        }
    }
    
    func format(_ c: Double, capped: Int) -> String {
        formatter.maximumFractionDigits = capped
        return formatter.string(from: c as NSNumber)!
    }
}
