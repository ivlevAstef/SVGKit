//
//  URL+Data.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 28/2/17.
//  Copyright 2020 Simon Whitty
//

// swiftlint:disable all

import Foundation

extension URL {
    
    init?(maybeData string: String) {
        guard string.hasPrefix("data:") else {
            self.init(string: string)
            return
        }
        
        var removed = string.replacingOccurrences(of: "\t", with: "")
        removed = removed.replacingOccurrences(of: "\n", with: "")
        removed = removed.replacingOccurrences(of: " ", with: "")
        
        self.init(string: removed)
    }
    
    
    var isDataURL: Bool {
        return scheme == "data"
    }
    
    var decodedData: (mimeType: String, data: Data)? {
        let txt = absoluteString
        guard let schemeRange = txt.range(of: "data:"),
              let mimeRange = txt.range(of: ";", options: [], range: schemeRange.upperBound..<txt.endIndex),
              let encodingRange = txt.range(
                of: "base64,",
                options: [],
                range: mimeRange.upperBound..<txt.endIndex
              ) else {
                  return nil
              }
        
        let mime = String(txt[schemeRange.upperBound..<mimeRange.lowerBound])
        let base64 = String(txt[encodingRange.upperBound..<txt.endIndex])
        
        guard !mime.isEmpty, !base64.isEmpty,
              let data = Data(base64Encoded: base64) else {
                  return nil
              }
        
        return (mime, data)
    }
}

// swiftlint:enable all
