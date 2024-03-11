// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct UInt6Set {
    public typealias Base = UInt64
    public typealias Element = UInt8

    public var bits: Base

    public init(_ bits: Base) {
        self.bits = bits
    }

    public init(_ values: some Sequence<Element>) {
        var bits: Base = 0
        for value in values {
            bits |= 1 << value
        }
        self.bits = bits
    }

    @inlinable
    public var count: Element { .init(bits.nonzeroBitCount) }

    @inlinable
    public var first: Element? { isEmpty ? nil : firstInNonEmpty }

    @inlinable
    public var firstInNonEmpty: Element { .init(bits.trailingZeroBitCount) }

    @inlinable
    public var last: Element? { isEmpty ? nil : lastInNonEmpty }

    @inlinable
    public var lastInNonEmpty: Element { .init(Int(UInt6.max) - bits.leadingZeroBitCount) }

    @inlinable
    public mutating func insert(_ value: Element) {
        bits |= 1 << value
    }

    @inlinable
    public mutating func remove(_ value: Element) {
        bits &= ~(1 << value)
    }

    @inlinable
    public func contains(_ value: Element) -> Bool {
        bits & (1 << value) != 0
    }

    @inlinable
    public var isEmpty: Bool { bits == 0 }

    public static let empty: Self = .init(0)
}

extension UInt6Set {
    @inlinable
    public func intersection(_ values: Self) -> Self {
        .init(bits & values.bits)
    }
    @inlinable
    public func intersection(_ values: some Sequence<Element>) -> Self {
        intersection(.init(values))
    }
    @inlinable
    mutating public func formUnion(_ values: Self) {
        bits |= values.bits
    }
    @inlinable
    public func union(_ values: Self) -> Self {
        .init(bits | values.bits)
    }
    @inlinable
    mutating public func subtract(_ values: Self) {
        bits &= ~values.bits
    }
    @inlinable
    public func subtracting(_ values: Self) -> Self {
        .init(bits & ~values.bits)
    }
    @inlinable
    public func inserting(_ value: Element) -> Self {
        .init(bits | (1 << value))
    }
    @inlinable
    public func removing(_ value: Element) -> Self {
        .init(bits & ~(1 << value))
    }
}

extension UInt6Set: Sequence {
    public struct UInt6SetIterator: IteratorProtocol {
        private var bits: Base
        private var value: Element = .max

        public init(_ values: UInt6Set) {
            self.bits = values.bits
        }

        mutating public func next() -> Element? {
            let offset = Element(bits.trailingZeroBitCount) + 1
            guard offset <= Base.bitWidth else { return nil }

            bits >>= offset
            value &+= offset
            return value
        }
    }

    @inlinable
    public func makeIterator() -> some IteratorProtocol<Element> {
        UInt6SetIterator(self)
    }
}

public struct UInt6 {
    public static let bitWidth: Int = 6
    public static let min: UInt8 = UInt8.min
    public static let max: UInt8 = UInt8.max >> (UInt8.bitWidth - bitWidth)
}

extension UInt6Set: CustomStringConvertible {
    public var description: String {
        "[\(self.map { "\($0)" }.joined(separator: ", "))]"
    }
}
