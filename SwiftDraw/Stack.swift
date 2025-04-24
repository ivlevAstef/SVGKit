//
//  Stack.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 15/6/17.
//  Copyright 2020 WhileLoop Pty Ltd. All rights reserved.
//

// swiftlint:disable all

struct Stack<Element> {
    private(set) var root: Element
    private(set) var storage: [Element]
    
    init(root: Element) {
        self.root = root
        storage = [Element]()
    }
    
    var top: Element {
        get {
            guard let last = storage.last else { return root }
            return last
        }
        set {
            guard storage.isEmpty else {
                storage.removeLast()
                storage.append(newValue)
                return
            }
            root = newValue
        }
    }
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Bool {
        guard !storage.isEmpty else { return false }
        storage.removeLast()
        return true
    }
}

// swiftlint:enable all
