//
//  StringFormat.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// `Timecode` string output format configuration.
    public typealias StringFormat = Set<StringFormatOption>
}

extension Timecode.StringFormat {
    /// Default timecode string formatting.
    public static func `default`() -> Self {
        []
    }
    
    /// Initialize with Show Subframes option enabled.
    public static let showSubFrames: Self = [.showSubFrames]
}

extension Timecode.StringFormat {
    /// Get or set ``Timecode/StringFormatOption/showSubFrames`` state.
    public var showSubFrames: Bool {
        get {
            contains(.showSubFrames)
        }
        set {
            if newValue { insert(.showSubFrames) }
            else { remove(.showSubFrames) }
        }
    }
    
    /// Get or set ``Timecode/StringFormatOption/filenameCompatible`` state.
    public var filenameCompatible: Bool {
        get {
            contains(.filenameCompatible)
        }
        set {
            if newValue { insert(.filenameCompatible) }
            else { remove(.filenameCompatible) }
        }
    }
}
