//
//  StringFormat.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    
    /// `Timecode` string output format configuration.
    public typealias StringFormat = Set<StringFormatParameter>
    
}

extension Timecode.StringFormat {
    
    public static func `default`() -> Self {
        []
    }
    
}

extension Timecode.StringFormat {
    
    public var showSubFrames: Bool {
        get {
            contains(.showSubFrames)
        }
        set {
            if newValue { insert(.showSubFrames) }
            else { remove(.showSubFrames) }
        }
    }
    
}

extension Timecode {
    
    /// `Timecode` string output format configuration parameter.
    public enum StringFormatParameter: Equatable, Hashable, CaseIterable {
        
        /// Determines whether subframes are included.
        ///
        /// This does not disable subframes from being stored or calculated, only whether they are output in the string.
        case showSubFrames
        
    }
    
}

extension Timecode.StringFormatParameter: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case showSubFrames = "showSubFrames"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let getString = try container.decode(String.self)
        guard let keyFromString = CodingKeys(rawValue: getString) else {
            throw DecodingError.valueNotFound(
                Self.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Decoded value is not valid.")
            )
        }
        
        switch keyFromString {
        case .showSubFrames:
            self = .showSubFrames
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        switch self {
        case .showSubFrames:
            try container.encode(CodingKeys.showSubFrames.rawValue)
        }
        
    }
    
}
