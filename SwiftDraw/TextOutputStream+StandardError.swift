//
//  TextOutputStream+StandardError.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 17/8/22.
//  Copyright 2022 Simon Whitty
//

// swiftlint:disable all

import Foundation

extension TextOutputStream where Self == StandardErrorStream {
    static var standardError: Self {
        get {
            StandardErrorStream.shared
        }
        set {
            StandardErrorStream.shared = newValue
        }
    }
}

struct StandardErrorStream: TextOutputStream {
    
    fileprivate static var shared = StandardErrorStream()
    
    func write(_ string: String) {
        if #available(macOS 10.15.4, iOS 13.4, *) {
            try! FileHandle.standardError.write(contentsOf: string.data(using: .utf8)!)
        } else {
            FileHandle.standardError.write(string.data(using: .utf8)!)
        }
    }
}

// swiftlint:enable all
