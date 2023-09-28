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
        case .fps23_98p:  return "23.98p"
        case .fps24p:     return "24p"
        case .fps25p:     return "25p"
        case .fps25i:     return "25i"
        case .fps29_97p:  return "29.97p"
        case .fps29_97i:  return "29.97i"
        case .fps30p:     return "30p"
        case .fps47_95p:  return "47.95p"
        case .fps48p:     return "48p"
        case .fps50p:     return "50p"
        case .fps50i:     return "50i"
        case .fps59_94p:  return "59.94p"
        case .fps59_94i:  return "59.94i"
        case .fps60p:     return "60p"
        case .fps60i:     return "60i"
        case .fps95_9p:   return "95.9p"
        case .fps96p:     return "96"
        case .fps100p:    return "100p"
        case .fps119_88p: return "119.88pp"
        case .fps120p:    return "120p"
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
        case .fps23_98p:  return Fraction(24000,  1001)
        case .fps24p:     return Fraction(24,     1)
        case .fps25p:     return Fraction(25,     1)
        case .fps25i:     return Fraction(25,     1)
        case .fps29_97p:  return Fraction(30000,  1001)
        case .fps29_97i:  return Fraction(30000,  1001)
        case .fps30p:     return Fraction(30,     1)
        case .fps47_95p:  return Fraction(48000,  1001)
        case .fps48p:     return Fraction(48,     1)
        case .fps50p:     return Fraction(50,     1)
        case .fps50i:     return Fraction(50,     1)
        case .fps59_94p:  return Fraction(60000,  1001)
        case .fps59_94i:  return Fraction(60000,  1001)
        case .fps60p:     return Fraction(60,     1)
        case .fps60i:     return Fraction(60,     1)
        case .fps95_9p:   return Fraction(96000,  1001)
        case .fps96p:     return Fraction(96,     1)
        case .fps100p:    return Fraction(100,    1)
        case .fps119_88p: return Fraction(120000, 1001)
        case .fps120p:    return Fraction(120,    1)
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
        case .fps23_98p:  return Fraction(1001, 24000)  // confirmed in FCP XML
        case .fps24p:     return Fraction(100,  2400)   // confirmed in FCP XML
        case .fps25p:     return Fraction(100,  2500)   // confirmed in FCP XML
        case .fps25i:     return Fraction(200,  5000)   // confirmed in FCP XML
        case .fps29_97p:  return Fraction(1001, 30000)  // confirmed in FCP XML
        case .fps29_97i:  return Fraction(2002, 60000)  // confirmed in FCP XML & QT tc track
        case .fps30p:     return Fraction(100,  3000)   // confirmed in FCP XML
        case .fps47_95p:  return Fraction(1001, 48000)  // inferred
        case .fps48p:     return Fraction(100,  4800)   // inferred
        case .fps50p:     return Fraction(100,  5000)   // confirmed in FCP XML
        case .fps50i:     return Fraction(200,  10000)  // inferred
        case .fps59_94p:  return Fraction(1001, 60000)  // confirmed in FCP XML
        case .fps59_94i:  return Fraction(2002, 120000) // inferred
        case .fps60p:     return Fraction(100,  6000)   // confirmed in FCP XML
        case .fps60i:     return Fraction(200,  12000)  // inferred
        case .fps95_9p:   return Fraction(1001, 96000)  // inferred
        case .fps96p:     return Fraction(100,  9600)   // inferred
        case .fps100p:    return Fraction(100,  10000)  // inferred
        case .fps119_88p: return Fraction(1001, 120000) // inferred
        case .fps120p:    return Fraction(100,  12000)  // inferred
        }
    }
    
    public var alternateFrameDuration: Fraction? {
        switch self {
        case .fps23_98p:  return Fraction(1000, 23976)
        case .fps24p:     return nil
        case .fps25p:     return nil
        case .fps25i:     return nil
        case .fps29_97p:  return Fraction(1000, 29970)
        case .fps29_97i:  return Fraction(2000, 59940) // inferred
        case .fps30p:     return nil
        case .fps47_95p:  return Fraction(1000, 47952)
        case .fps48p:     return nil
        case .fps50p:     return nil
        case .fps50i:     return nil
        case .fps59_94p:  return Fraction(1000, 59940)
        case .fps59_94i:  return Fraction(2000, 119880) // inferred
        case .fps60p:     return nil
        case .fps60i:     return nil
        case .fps95_9p:   return Fraction(1000, 95904)
        case .fps96p:     return nil
        case .fps100p:    return nil
        case .fps119_88p: return Fraction(1000, 119880)
        case .fps120p:    return nil
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
        case .fps23_98p:  return false
        case .fps24p:     return false
        case .fps25p:     return false
        case .fps25i:     return true
        case .fps29_97p:  return false
        case .fps29_97i:  return true
        case .fps30p:     return false
        case .fps47_95p:  return false
        case .fps48p:     return false
        case .fps50p:     return false
        case .fps50i:     return true
        case .fps59_94p:  return false
        case .fps59_94i:  return true
        case .fps60p:     return false
        case .fps60i:     return true
        case .fps95_9p:   return false
        case .fps96p:     return false
        case .fps100p:    return false
        case .fps119_88p: return false
        case .fps120p:    return false
        }
    }
}
