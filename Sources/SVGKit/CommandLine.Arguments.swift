//
//  CommandLine.Arguments.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 7/12/18.
//  Copyright 2020 Simon Whitty
//

import Foundation

// swiftlint:disable all

extension CommandLine {
    
    enum Error: Swift.Error {
        case invalid
        case unsupported
        case fileNotFound
    }
    
    enum Modifier: String {
        case format
        case output
        case size
        case insets
        case scale
        case precision
        case api
        case ultralight
        case ultralightInsets
        case black
        case blackInsets
        case hideUnsupportedFilters
        
        var hasValue: Bool {
            self != .hideUnsupportedFilters
        }
    }
    
    static func parseModifiers(from args: [String]) throws -> [Modifier: String?] {
        var args = args
        var modifiers = [Modifier: String?]()
        while let pair = try args.takeModifier() {
            if modifiers.keys.contains(pair.0) == false {
                modifiers[pair.0] = pair.1
            } else {
                throw Error.invalid
            }
        }
        
        guard args.isEmpty else {
            throw CommandLine.Error.invalid
        }
        
        return modifiers
    }
}

private extension Array where Element == String {
    
    mutating func takeModifier() throws -> (CommandLine.Modifier, String?)? {
        guard !isEmpty else {
            return nil
        }
        
        guard self[0].hasPrefix("--"),
              let modifier = CommandLine.Modifier(rawValue: String(self[0].dropFirst(2))) else {
                  throw CommandLine.Error.invalid
              }
        
        if modifier.hasValue {
            guard count > 1 else {
                throw CommandLine.Error.invalid
            }
            defer { removeFirst(2) }
            return (modifier, self[1])
        } else {
            removeFirst(1)
            return (modifier, nil)
        }
    }
}

// swiftlint:enable all
