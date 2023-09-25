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

extension Timecode {
    /// `Timecode` string output format option.
    public enum StringFormatOption: Equatable, Hashable, CaseIterable {
        /// Determines whether subframes are included.
        ///
        /// This does not disable subframes from being stored or calculated, only whether it is present in the string.
        case showSubFrames
        
        /// Substitutes illegal characters for filename-compatible characters.
        case filenameCompatible
    }
}

extension Timecode.StringFormatOption: Codable {
    private enum CodingKeys: String, CodingKey {
        case showSubFrames
        case filenameCompatible
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let getString = try container.decode(String.self)
        guard let keyFromString = CodingKeys(rawValue: getString) else {
            throw DecodingError.valueNotFound(
                Self.self,
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Decoded value is not valid."
                )
            )
        }
        
        switch keyFromString {
        case .showSubFrames:
            self = .showSubFrames
        case .filenameCompatible:
            self = .filenameCompatible
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .showSubFrames:
            try container.encode(CodingKeys.showSubFrames.rawValue)
        case .filenameCompatible:
            try container.encode(CodingKeys.filenameCompatible.rawValue)
        }
    }
}
