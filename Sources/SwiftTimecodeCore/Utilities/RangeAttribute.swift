//
//  RangeAttribute.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// An individual time attribute of a time range.
@_documentation(visibility: internal)
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
