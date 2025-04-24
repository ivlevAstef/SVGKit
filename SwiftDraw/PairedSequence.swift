//
//  PairedSequence.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 6/8/22.
//  Copyright 2022 Simon Whitty
//

extension Sequence {
    
    // Iterate a sequence by including the next element each time.
    // A---B---C---D
    //
    // nextSkippingLast: (A,B)--(B,C)--(C,D)
    // nextWrappingToFirst: (A,B)--(B,C)--(C,D)--(D,A)
    func paired(with options: PairedSequence<Self>.Options = .nextWrappingToFirst) -> PairedSequence<Self> {
        PairedSequence(self, options: options)
    }
}

struct PairedSequence<S: Sequence>: Sequence {
    typealias Element = (S.Element, next: S.Element)
    
    enum Options {
        case nextSkippingLast
        case nextWrappingToFirst
    }
    
    struct Iterator: IteratorProtocol {
        private var inner: S.Iterator
        private let options: Options
        
        init(_ inner: S.Iterator, options: Options) {
            self.inner = inner
            self.options = options
        }
        
        mutating func next() -> (S.Element, next: S.Element)? {
            guard !isComplete else {
                return nil
            }
            
            guard let element = inner.next() else {
                isComplete = true
                return makeWrappedIfRequired()
            }
            
            if let previous {
                self.previous = element
                return (previous, element)
            } else {
                first = element
                if let another = inner.next() {
                    self.previous = another
                    return (element, another)
                } else {
                    isComplete = true
                    return nil
                }
            }
        }
        
        private mutating func makeWrappedIfRequired() -> (S.Element, next: S.Element)? {
            guard options == .nextWrappingToFirst,
                  let first,
                  let previous else {
                      return nil
                  }
            self.first = nil
            self.previous = nil
            return (previous, first)
        }
        
        private var isComplete = false
        private var first: S.Element?
        private var previous: S.Element?
    }
    
    private let inner: S
    private let options: Options
    
    init(_ inner: S, options: Options) {
        self.inner = inner
        self.options = options
    }
    
    func makeIterator() -> Iterator {
        return Iterator(inner.makeIterator(), options: options)
    }
}
