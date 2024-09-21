//
//  Component.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Individual timecode component.
    public enum Component: Equatable, Hashable, CaseIterable {
        case days
        case hours
        case minutes
        case seconds
        case frames
        case subFrames
    }
}

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.Component: Identifiable {
    public var id: Self { self }
}

extension Timecode.Component: Sendable { }
