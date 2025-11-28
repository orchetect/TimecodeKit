//
//  VideoFrameRate Properties.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension VideoFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case .fps23_98p:  "23.98p"
        case .fps24p:     "24p"
        case .fps25p:     "25p"
        case .fps25i:     "25i"
        case .fps29_97p:  "29.97p"
        case .fps29_97i:  "29.97i"
        case .fps30p:     "30p"
        case .fps47_95p:  "47.95p"
        case .fps48p:     "48p"
        case .fps50p:     "50p"
        case .fps50i:     "50i"
        case .fps59_94p:  "59.94p"
        case .fps59_94i:  "59.94i"
        case .fps60p:     "60p"
        case .fps60i:     "60i"
        case .fps90p:     "90p"
        case .fps95_9p:   "95.9p"
        case .fps96p:     "96p"
        case .fps100p:    "100p"
        case .fps119_88p: "119.88pp"
        case .fps120p:    "120p"
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
        case .fps23_98p:  Fraction(24000,  1001)
        case .fps24p:     Fraction(24,     1)
        case .fps25p:     Fraction(25,     1)
        case .fps25i:     Fraction(25,     1)
        case .fps29_97p:  Fraction(30000,  1001)
        case .fps29_97i:  Fraction(30000,  1001)
        case .fps30p:     Fraction(30,     1)
        case .fps47_95p:  Fraction(48000,  1001)
        case .fps48p:     Fraction(48,     1)
        case .fps50p:     Fraction(50,     1)
        case .fps50i:     Fraction(50,     1)
        case .fps59_94p:  Fraction(60000,  1001)
        case .fps59_94i:  Fraction(60000,  1001)
        case .fps60p:     Fraction(60,     1)
        case .fps60i:     Fraction(60,     1)
        case .fps90p:     Fraction(90,     1)
        case .fps95_9p:   Fraction(96000,  1001)
        case .fps96p:     Fraction(96,     1)
        case .fps100p:    Fraction(100,    1)
        case .fps119_88p: Fraction(120000, 1001)
        case .fps120p:    Fraction(120,    1)
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
        case .fps23_98p:  Fraction(1001, 24000)  // confirmed in FCP XML 1.12
        case .fps24p:     Fraction(100,  2400)   // confirmed in FCP XML 1.12
        case .fps25p:     Fraction(100,  2500)   // confirmed in FCP XML 1.12
        case .fps25i:     Fraction(200,  5000)   // confirmed in FCP XML 1.12
        case .fps29_97p:  Fraction(1001, 30000)  // confirmed in FCP XML 1.12
        case .fps29_97i:  Fraction(2002, 60000)  // confirmed in FCP XML 1.12 & QT timecode track
        case .fps30p:     Fraction(100,  3000)   // confirmed in FCP XML 1.12
        case .fps47_95p:  Fraction(1001, 48000)  // inferred
        case .fps48p:     Fraction(100,  4800)   // inferred
        case .fps50p:     Fraction(100,  5000)   // confirmed in FCP XML 1.12
        case .fps50i:     Fraction(200,  10000)  // inferred
        case .fps59_94p:  Fraction(1001, 60000)  // confirmed in FCP XML 1.12
        case .fps59_94i:  Fraction(2002, 120000) // inferred
        case .fps60p:     Fraction(100,  6000)   // confirmed in FCP XML 1.12
        case .fps60i:     Fraction(200,  12000)  // inferred
        case .fps90p:     Fraction(100,  9000)   // confirmed in FCP XML 1.13
        case .fps95_9p:   Fraction(1001, 96000)  // inferred
        case .fps96p:     Fraction(100,  9600)   // inferred
        case .fps100p:    Fraction(100,  10000)  // inferred
        case .fps119_88p: Fraction(1001, 120000) // inferred
        case .fps120p:    Fraction(100,  12000)  // inferred
        }
    }
    
    public var alternateFrameDuration: Fraction? {
        switch self {
        case .fps23_98p:  Fraction(1000, 23976)
        case .fps24p:     nil
        case .fps25p:     nil
        case .fps25i:     nil
        case .fps29_97p:  Fraction(1000, 29970)
        case .fps29_97i:  Fraction(2000, 59940) // inferred
        case .fps30p:     nil
        case .fps47_95p:  Fraction(1000, 47952)
        case .fps48p:     nil
        case .fps50p:     nil
        case .fps50i:     nil
        case .fps59_94p:  Fraction(1000, 59940)
        case .fps59_94i:  Fraction(2000, 119880) // inferred
        case .fps60p:     nil
        case .fps60i:     nil
        case .fps90p:     nil
        case .fps95_9p:   Fraction(1000, 95904)
        case .fps96p:     nil
        case .fps100p:    nil
        case .fps119_88p: Fraction(1000, 119880)
        case .fps120p:    nil
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
        case .fps23_98p:  false
        case .fps24p:     false
        case .fps25p:     false
        case .fps25i:     true
        case .fps29_97p:  false
        case .fps29_97i:  true
        case .fps30p:     false
        case .fps47_95p:  false
        case .fps48p:     false
        case .fps50p:     false
        case .fps50i:     true
        case .fps59_94p:  false
        case .fps59_94i:  true
        case .fps60p:     false
        case .fps60i:     true
        case .fps90p:     false
        case .fps95_9p:   false
        case .fps96p:     false
        case .fps100p:    false
        case .fps119_88p: false
        case .fps120p:    false
        }
    }
}
