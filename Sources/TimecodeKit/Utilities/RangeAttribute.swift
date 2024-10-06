//
//  RangeAttribute.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

/// An individual time attribute of a time range.
public enum RangeAttribute: Equatable, Hashable {
    case start
    case end
    case duration
}

extension RangeAttribute: Sendable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension RangeAttribute: Identifiable {
    public var id: Self { self }
}
