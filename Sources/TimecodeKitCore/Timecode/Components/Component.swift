//
//  Component.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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

extension Timecode.Component: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.Component: Identifiable {
    public var id: Self { self }
}

extension Timecode.Component: Sendable { }

// MARK: - Sequence Traversal

extension Timecode.Component {
    /// Returns the first timecode component in sequence.
    public static func first(excluding: Set<Self> = []) -> Self {
        let components = allCases.filter { !excluding.contains($0) }
        precondition(!components.isEmpty)
        return components.first!
    }
    
    /// Returns the last timecode component in sequence.
    public static func last(excluding: Set<Self> = []) -> Self {
        let components = allCases.filter { !excluding.contains($0) }
        precondition(!components.isEmpty)
        return components.last!
    }
    
    /// Returns the next timecode component in sequence.
    ///
    /// - Parameters:
    ///   - excluding: Components to exclude from the available set of components.
    ///   - wrap: When `true`, if the component is the last in the sequence, the sequence wraps around and returns the
    ///     first component.
    public func next(excluding: Set<Self> = [], wrap: Bool = true) -> Self {
        let components = Self.allCases.filter { !excluding.contains($0) }
        
        precondition(!components.isEmpty)
        
        guard let index = components.firstIndex(of: self) else {
            return components.first!
        }
        
        let offsetIndex = index.advanced(by: 1)
        
        if components.indices.contains(offsetIndex) {
            return components[offsetIndex]
        } else {
            return wrap ? components.first! : components[index]
        }
    }
    
    /// Returns the previous timecode component in sequence.
    ///
    /// - Parameters:
    ///   - excluding: Components to exclude from the available set of components.
    ///   - wrap: When `true`, if the component is the last in the sequence, the sequence wraps around and returns the
    ///     last component.
    public func previous(excluding: Set<Self> = [], wrap: Bool = true) -> Self {
        let components = Self.allCases.filter { !excluding.contains($0) }
        
        precondition(!components.isEmpty)
        
        guard let index = components.firstIndex(of: self) else {
            return components.last!
        }
        
        let offsetIndex = index.advanced(by: -1)
        
        if components.indices.contains(offsetIndex) {
            return components[offsetIndex]
        } else {
            return wrap ? components.last! : components[index]
        }
    }
}

// MARK: - Properties

extension Timecode.Component {
    /// Returns the number of digit places the component occupies in a timecode string or a timecode edit field user
    /// interface.
    public func numberOfDigits(
        at rate: TimecodeFrameRate,
        base: Timecode.SubFramesBase
    ) -> Int {
        switch self {
        case .days: 2
        case .hours: 2
        case .minutes: 2
        case .seconds: 2
        case .frames: rate.numberOfDigits
        case .subFrames: base.numberOfDigits
        }
    }
    
    /// Returns the name of the component as a lowerCamelCase string (identical to case name).
    public var nameLowerCamelCase: String {
        switch self {
        case .days: "days"
        case .hours: "hours"
        case .minutes: "minutes"
        case .seconds: "seconds"
        case .frames: "frames"
        case .subFrames: "subFrames"
        }
    }
    
    /// Returns the name of the component as a capitalized string.
    public var nameCapitalized: String {
        switch self {
        case .days: "Days"
        case .hours: "Hours"
        case .minutes: "Minutes"
        case .seconds: "Seconds"
        case .frames: "Frames"
        case .subFrames: "SubFrames"
        }
    }
    
    /// Returns the name of the component as a lowercase string.
    public var nameLowercased: String {
        switch self {
        case .days: "days"
        case .hours: "hours"
        case .minutes: "minutes"
        case .seconds: "seconds"
        case .frames: "frames"
        case .subFrames: "subframes"
        }
    }
}
