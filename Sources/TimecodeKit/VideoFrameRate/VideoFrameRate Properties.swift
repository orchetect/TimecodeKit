//
//  VideoFrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension VideoFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case ._23_98p: return "23.98p"
        case ._24p:    return "24p"
        case ._25p:    return "25p"
        case ._25i:    return "25i"
        case ._29_97p: return "29.97p"
        case ._29_97i: return "29.97i"
        case ._30p:    return "30p"
        case ._50p:    return "50p"
        case ._50i:    return "50i"
        case ._59_94p: return "59.95p"
        case ._60p:    return "60p"
        case ._60i:    return "60i"
        }
    }
    
    /// Initializes from a ``stringValue`` string. Case-sensitive.
    public init?(stringValue: String) {
        if let findMatch = Self.allCases
            .first(where: { $0.stringValue == stringValue })
        {
            self = findMatch
        } else {
            return nil
        }
    }
}

// MARK: Public meta properties

extension VideoFrameRate {
    /// Returns the frame rate expressed as a rational number (fraction).
    ///
    /// - Note: Since drop rate is not embeddable in a fraction, the ``isDrop`` flag must be
    /// preserved whenever this information is encoded elsewhere.
    ///
    ///     // == frame rate
    ///     Double(numerator) / Double(denominator)
    ///
    ///     // == duration of 1 frame in seconds
    ///     Double(denominator) / Double(numerator)
    public var rationalFrameRate: (numerator: Int, denominator: Int) {
        switch self {
        case ._23_98p: return (numerator: 24000,   denominator: 1001)
        case ._24p:    return (numerator: 24,      denominator: 1)
        case ._25p:    return (numerator: 25,      denominator: 1)
        case ._25i:    return (numerator: 25,      denominator: 1)
        case ._29_97p: return (numerator: 30000,   denominator: 1001)
        case ._29_97i: return (numerator: 30000,   denominator: 1001)
        case ._30p:    return (numerator: 30,      denominator: 1)
        case ._50p:    return (numerator: 50,      denominator: 1)
        case ._50i:    return (numerator: 50,      denominator: 1)
        case ._59_94p: return (numerator: 60000,   denominator: 1001)
        case ._60p:    return (numerator: 60,      denominator: 1)
        case ._60i:    return (numerator: 60,      denominator: 1)
        }
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction).
    ///
    /// - Note: Since drop rate is not embeddable in a fraction, the ``isDrop`` flag must be
    /// preserved whenever this information is encoded elsewhere.
    ///
    /// - Note: Compatible with FCP XML v1.6 - 1.9.
    ///         Potentially compatible outside of that range but untested.
    public var rationalFrameDuration: (numerator: Int, denominator: Int) {
        switch self {
        case ._23_98p: return (numerator: 1001, denominator: 24000) // confirmed in FCP XML
        case ._24p:    return (numerator: 100,  denominator: 2400)  // confirmed in FCP XML
        case ._25p:    return (numerator: 100,  denominator: 2500)  // confirmed in FCP XML
        case ._25i:    return (numerator: 200,  denominator: 5000)  // confirmed in FCP XML
        case ._29_97p: return (numerator: 1001, denominator: 30000) // confirmed in FCP XML
        case ._29_97i: return (numerator: 2002, denominator: 60000) // confirmed in FCP XML
        case ._30p:    return (numerator: 100,  denominator: 3000)  // confirmed in FCP XML
        case ._50p:    return (numerator: 100,  denominator: 5000)  // confirmed in FCP XML
        case ._50i:    return (numerator: 200,  denominator: 10000) // inferred
        case ._59_94p: return (numerator: 1001, denominator: 60000) // confirmed in FCP XML
        case ._60p:    return (numerator: 100,  denominator: 6000)  // confirmed in FCP XML
        case ._60i:    return (numerator: 200,  denominator: 12000) // inferred
        }
    }
}

#if canImport(CoreMedia)
import CoreMedia

extension VideoFrameRate {
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    public var rationalFrameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rationalFrameDuration.numerator),
            timescale: CMTimeScale(rationalFrameDuration.denominator)
        )
    }
}
#endif
