//
//  VideoFrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension VideoFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case ._23_98p:  return "23.98p"
        case ._24p:     return "24p"
        case ._25p:     return "25p"
        case ._25i:     return "25i"
        case ._29_97p:  return "29.97p"
        case ._29_97i:  return "29.97i"
        case ._30p:     return "30p"
        case ._47_95p:  return "47.95p"
        case ._48p:     return "48p"
        case ._50p:     return "50p"
        case ._50i:     return "50i"
        case ._59_94p:  return "59.94p"
        case ._59_94i:  return "59.94i"
        case ._60p:     return "60p"
        case ._60i:     return "60i"
        case ._95_9p:   return "95.9p"
        case ._96p:     return "96"
        case ._100p:    return "100p"
        case ._119_88p: return "119.88pp"
        case ._120p:    return "120p"
        }
    }
    
    /// Initializes from the human-readable ``stringValue`` string. Case-sensitive.
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
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled.
    ///
    /// ```swift
    /// // == frame rate
    /// Double(numerator) / Double(denominator)
    ///
    /// // == duration of 1 frame in seconds
    /// Double(denominator) / Double(numerator)
    /// ```
    public var rate: Fraction {
        switch self {
        case ._23_98p:  return Fraction(24000,  1001)
        case ._24p:     return Fraction(24,     1)
        case ._25p:     return Fraction(25,     1)
        case ._25i:     return Fraction(25,     1)
        case ._29_97p:  return Fraction(30000,  1001)
        case ._29_97i:  return Fraction(30000,  1001)
        case ._30p:     return Fraction(30,     1)
        case ._47_95p:  return Fraction(48000,  1001)
        case ._48p:     return Fraction(48,     1)
        case ._50p:     return Fraction(50,     1)
        case ._50i:     return Fraction(50,     1)
        case ._59_94p:  return Fraction(60000,  1001)
        case ._59_94i:  return Fraction(60000,  1001)
        case ._60p:     return Fraction(60,     1)
        case ._60i:     return Fraction(60,     1)
        case ._95_9p:   return Fraction(96000,  1001)
        case ._96p:     return Fraction(96,     1)
        case ._100p:    return Fraction(100,    1)
        case ._119_88p: return Fraction(120000, 1001)
        case ._120p:    return Fraction(120,    1)
        }
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction).
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled.
    ///
    /// - Note: Compatible with FCP XML v1.6 - 1.9.
    ///         Potentially compatible outside of that range but untested.
    public var frameDuration: Fraction {
        switch self {
        case ._23_98p:  return Fraction(1001, 24000)  // confirmed in FCP XML
        case ._24p:     return Fraction(100,  2400)   // confirmed in FCP XML
        case ._25p:     return Fraction(100,  2500)   // confirmed in FCP XML
        case ._25i:     return Fraction(200,  5000)   // confirmed in FCP XML
        case ._29_97p:  return Fraction(1001, 30000)  // confirmed in FCP XML
        case ._29_97i:  return Fraction(2002, 60000)  // confirmed in FCP XML & QT tc track
        case ._30p:     return Fraction(100,  3000)   // confirmed in FCP XML
        case ._47_95p:  return Fraction(1001, 48000)  // inferred
        case ._48p:     return Fraction(100,  4800)   // inferred
        case ._50p:     return Fraction(100,  5000)   // confirmed in FCP XML
        case ._50i:     return Fraction(200,  10000)  // inferred
        case ._59_94p:  return Fraction(1001, 60000)  // confirmed in FCP XML
        case ._59_94i:  return Fraction(2002, 120000) // inferred
        case ._60p:     return Fraction(100,  6000)   // confirmed in FCP XML
        case ._60i:     return Fraction(200,  12000)  // inferred
        case ._95_9p:   return Fraction(1001, 96000)  // inferred
        case ._96p:     return Fraction(100,  9600)   // inferred
        case ._100p:    return Fraction(100,  10000)  // inferred
        case ._119_88p: return Fraction(1001, 120000) // inferred
        case ._120p:    return Fraction(100,  12000)  // inferred
        }
    }
    
    public var alternateFrameDuration: Fraction? {
        switch self {
        case ._23_98p:  return Fraction(1000, 23976)
        case ._24p:     return nil
        case ._25p:     return nil
        case ._25i:     return nil
        case ._29_97p:  return Fraction(1000, 29970)
        case ._29_97i:  return Fraction(2000, 59940) // inferred
        case ._30p:     return nil
        case ._47_95p:  return Fraction(1000, 47952)
        case ._48p:     return nil
        case ._50p:     return nil
        case ._50i:     return nil
        case ._59_94p:  return Fraction(1000, 59940)
        case ._59_94i:  return Fraction(2000, 119880) // inferred
        case ._60p:     return nil
        case ._60i:     return nil
        case ._95_9p:   return Fraction(1000, 95904)
        case ._96p:     return nil
        case ._100p:    return nil
        case ._119_88p: return Fraction(1000, 119880)
        case ._120p:    return nil
        }
    }
    
    /// Returns the frame rate expressed as floating-point frames per second (fps).
    public var fps: Double {
        let frac = rate
        return Double(frac.numerator) / Double(frac.denominator)
    }
    
    /// Returns `true` if frame rate is interlaced, otherwise `false` if progressive.
    public var isInterlaced: Bool {
        switch self {
        case ._23_98p:  return false
        case ._24p:     return false
        case ._25p:     return false
        case ._25i:     return true
        case ._29_97p:  return false
        case ._29_97i:  return true
        case ._30p:     return false
        case ._47_95p:  return false
        case ._48p:     return false
        case ._50p:     return false
        case ._50i:     return true
        case ._59_94p:  return false
        case ._59_94i:  return true
        case ._60p:     return false
        case ._60i:     return true
        case ._95_9p:   return false
        case ._96p:     return false
        case ._100p:    return false
        case ._119_88p: return false
        case ._120p:    return false
        }
    }
}
