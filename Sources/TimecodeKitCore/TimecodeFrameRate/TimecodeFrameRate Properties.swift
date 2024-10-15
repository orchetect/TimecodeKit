//
//  TimecodeFrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension TimecodeFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case .fps23_976:  "23.976"
        case .fps24:      "24"
        case .fps24_98:   "24.98"
        case .fps25:      "25"
        case .fps29_97:   "29.97"
        case .fps29_97d:  "29.97d"
        case .fps30:      "30"
        case .fps30d:     "30d"
        case .fps47_952:  "47.952"
        case .fps48:      "48"
        case .fps50:      "50"
        case .fps59_94:   "59.94"
        case .fps59_94d:  "59.94d"
        case .fps60:      "60"
        case .fps60d:     "60d"
        case .fps95_904:  "95.904"
        case .fps96:      "96"
        case .fps100:     "100"
        case .fps119_88:  "119.88"
        case .fps119_88d: "119.88d"
        case .fps120:     "120"
        case .fps120d:    "120d"
        }
    }
    
    /// Returns human-readable frame rate string in long form.
    public var stringValueVerbose: String {
        switch self {
        case .fps23_976:  "23.976 fps"
        case .fps24:      "24 fps"
        case .fps24_98:   "24.98 fps"
        case .fps25:      "25 fps"
        case .fps29_97:   "29.97 fps"
        case .fps29_97d:  "29.97 fps drop"
        case .fps30:      "30 fps"
        case .fps30d:     "30 fps drop"
        case .fps47_952:  "47.952 fps"
        case .fps48:      "48 fps"
        case .fps50:      "50 fps"
        case .fps59_94:   "59.94 fps"
        case .fps59_94d:  "59.94 fps drop"
        case .fps60:      "60 fps"
        case .fps60d:     "60 fps drop"
        case .fps95_904:  "95.904 fps"
        case .fps96:      "96 fps"
        case .fps100:     "100 fps"
        case .fps119_88:  "119.88 fps"
        case .fps119_88d: "119.88 fps drop"
        case .fps120:     "120 fps"
        case .fps120d:    "120 fps drop"
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

extension TimecodeFrameRate {
    /// Returns the frame rate expressed as a rational number (fraction).
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled. (``isDrop``)
    ///
    /// ```swift
    /// Double(numerator) / Double(denominator)
    /// // == frame rate
    ///
    /// Double(denominator) / Double(numerator)
    /// // == duration of 1 frame in seconds
    /// ```
    public var rate: Fraction {
        switch self {
        case .fps23_976:  Fraction(24000,   1001)
        case .fps24:      Fraction(24,      1)
        case .fps24_98:   Fraction(25000,   1001)
        case .fps25:      Fraction(25,      1)
        case .fps29_97:   Fraction(30000,   1001)
        case .fps29_97d:  Fraction(30000,   1001)
        case .fps30:      Fraction(30,      1)
        case .fps30d:     Fraction(30,      1)
        case .fps47_952:  Fraction(48000,   1001)
        case .fps48:      Fraction(48,      1)
        case .fps50:      Fraction(50,      1)
        case .fps59_94:   Fraction(60000,   1001)
        case .fps59_94d:  Fraction(60000,   1001)
        case .fps60:      Fraction(60,      1)
        case .fps60d:     Fraction(60,      1)
        case .fps95_904:  Fraction(96000,   1001)
        case .fps96:      Fraction(96,      1)
        case .fps100:     Fraction(100,     1)
        case .fps119_88:  Fraction(120_000, 1001)
        case .fps119_88d: Fraction(120_000, 1001)
        case .fps120:     Fraction(120,     1)
        case .fps120d:    Fraction(120,     1)
        }
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction).
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled. (``isDrop``)
    ///
    /// - Note: Compatible with FCP XML v1.6 - 1.9.
    ///         Potentially compatible outside of that range but untested.
    public var frameDuration: Fraction {
        switch self {
        case .fps23_976:  Fraction(1001, 24000)
        case .fps24:      Fraction(100,  2400)
        case .fps24_98:   Fraction(1001, 25000) // TODO: inferred
        case .fps25:      Fraction(100,  2500)
        case .fps29_97:   Fraction(1001, 30000)
        case .fps29_97d:  Fraction(1001, 30000)
        case .fps30:      Fraction(100,  3000)
        case .fps30d:     Fraction(100,  3000) // TODO: needs checking
        case .fps47_952:  Fraction(1001, 48000) // TODO: inferred
        case .fps48:      Fraction(100,  4800)
        case .fps50:      Fraction(100,  5000)
        case .fps59_94:   Fraction(1001, 60000) // TODO: inferred
        case .fps59_94d:  Fraction(1001, 60000) // TODO: inferred
        case .fps60:      Fraction(100,  6000)
        case .fps60d:     Fraction(100,  6000) // TODO: needs checking
        case .fps95_904:  Fraction(1001, 96000) // TODO: inferred
        case .fps96:      Fraction(100,  9600) // TODO: inferred
        case .fps100:     Fraction(100,  10000)
        case .fps119_88:  Fraction(1001, 120000) // TODO: inferred
        case .fps119_88d: Fraction(1001, 120000) // TODO: inferred
        case .fps120:     Fraction(100,  12000)
        case .fps120d:    Fraction(100,  12000) // TODO: needs checking
        }
    }
    
    /// Alternate frame durations used, such as QuickTime timecode track.
    /// Some encoders errantly encode frame rate fractions,
    /// so we can fall back to these values a secondary checks.
    public var alternateFrameDuration: Fraction? {
        switch self {
        case .fps23_976:  Fraction(1000, 23976) // seen in the wild
        case .fps24:      nil
        case .fps24_98:   Fraction(1000, 24980) // TODO: inferred
        case .fps25:      nil
        case .fps29_97:   Fraction(1000, 29970) // seen in the wild
        case .fps29_97d:  Fraction(1000, 29970) // seen in the wild
        case .fps30:      nil
        case .fps30d:     nil // TODO: needs checking
        case .fps47_952:  Fraction(1000, 47952) // TODO: inferred
        case .fps48:      nil
        case .fps50:      nil
        case .fps59_94:   Fraction(1000, 59940) // TODO: inferred
        case .fps59_94d:  Fraction(1000, 59940) // TODO: inferred
        case .fps60:      nil
        case .fps60d:     nil // TODO: needs checking
        case .fps95_904:  Fraction(1000, 95904) // TODO: inferred
        case .fps96:      nil
        case .fps100:     nil
        case .fps119_88:  Fraction(1000, 119880) // TODO: inferred
        case .fps119_88d: Fraction(1000, 119880) // TODO: inferred
        case .fps120:     nil
        case .fps120d:    nil // TODO: needs checking
        }
    }
    
    /// Returns `true` if frame rate is drop.
    public var isDrop: Bool {
        switch self {
        case .fps23_976:  false
        case .fps24:      false
        case .fps24_98:   false
        case .fps25:      false
        case .fps29_97:   false
        case .fps29_97d:  true
        case .fps30:      false
        case .fps30d:     true
        case .fps47_952:  false
        case .fps48:      false
        case .fps50:      false
        case .fps59_94:   false
        case .fps59_94d:  true
        case .fps60:      false
        case .fps60d:     true
        case .fps95_904:  false
        case .fps96:      false
        case .fps100:     false
        case .fps119_88:  false
        case .fps119_88d: true
        case .fps120:     false
        case .fps120d:    true
        }
    }
    
    /// Returns the number of digits required for frames within the timecode string.
    ///
    /// ie: 24 or 30 fps would return `2`, but 120 fps would return `3`.
    public var numberOfDigits: Int {
        switch self {
        case .fps23_976,
             .fps24,
             .fps24_98,
             .fps25,
             .fps29_97,
             .fps29_97d,
             .fps30,
             .fps30d,
             .fps47_952,
             .fps48,
             .fps50,
             .fps59_94,
             .fps59_94d,
             .fps60,
             .fps60d,
             .fps95_904,
             .fps96,
             .fps100:
            
            2
            
        case .fps119_88,
             .fps119_88d,
             .fps120,
             .fps120d:
            
            3
        }
    }
    
    /// Max frame number displayable before seconds roll over.
    public var maxFrameNumberDisplayable: Int {
        maxFrames - 1
    }
    
    /// Returns max total frames from 0 to and including rolling over to `extent`.
    public func maxTotalFrames(in extent: Timecode.UpperLimit) -> Int {
        switch extent {
        case .max24Hours:
            switch self {
            case .fps23_976:  2_073_600  // @ 24hours
            case .fps24:      2_073_600  // @ 24hours
            case .fps24_98:   2_160_000  // @ 24hours
            case .fps25:      2_160_000  // @ 24hours
            case .fps29_97:   2_592_000  // @ 24hours
            case .fps29_97d:  2_589_408  // @ 24hours
            case .fps30:      2_592_000  // @ 24hours
            case .fps30d:     2_589_408  // @ 24hours
            case .fps47_952:  4_147_200  // @ 24hours
            case .fps48:      4_147_200  // @ 24hours
            case .fps50:      4_320_000  // @ 24hours
            case .fps59_94:   5_184_000  // @ 24hours (.fps29_97 * 2 in theory)
            case .fps59_94d:  5_178_816  // @ 24hours (.fps29_97d * 2, in theory)
            case .fps60:      5_184_000  // @ 24hours
            case .fps60d:     5_178_816  // @ 24hours
            case .fps95_904:  8_294_400  // @ 24hours
            case .fps96:      8_294_400  // @ 24hours
            case .fps100:     8_640_000  // @ 24hours
            case .fps119_88:  10_368_000 // @ 24hours (.fps29_97 * 4 in theory)
            case .fps119_88d: 10_357_632 // @ 24hours (.fps29_97d * 4, in theory)
            case .fps120:     10_368_000 // @ 24hours
            case .fps120d:    10_357_632 // @ 24hours
            }
            
        case .max100Days:
            maxTotalFrames(in: .max24Hours) * extent.maxDays
        }
    }
    
    /// Returns max elapsed frames possible before rolling over to 0.
    /// (Number of frames from 0 to `extent` minus one frame).
    public func maxTotalFramesExpressible(in extent: Timecode.UpperLimit) -> Int {
        maxTotalFrames(in: extent) - 1
    }
    
    /// Returns max total subframes from 0 to and including rolling over to `extent`.
    public func maxTotalSubFrames(
        in extent: Timecode.UpperLimit,
        base: Timecode.SubFramesBase
    ) -> Int {
        maxTotalFrames(in: extent) * base.rawValue
    }
    
    /// Returns max elapsed subframes possible before rolling over to 0.
    /// (Number of subframes from 0 to `extent` minus one subframe).
    public func maxSubFrameCountExpressible(
        in extent: Timecode.UpperLimit,
        base: Timecode.SubFramesBase
    ) -> Int {
        maxTotalSubFrames(in: extent, base: base) - 1
    }
}

// MARK: Internal properties

extension TimecodeFrameRate {
    /// Internal use.
    /// Constant for total number of elapsed frames that comprise 1 'second' of timecode.
    package var maxFrames: Int {
        switch self {
        case .fps23_976:  24
        case .fps24:      24
        case .fps24_98:   25
        case .fps25:      25
        case .fps29_97:   30
        case .fps29_97d:  30
        case .fps30:      30
        case .fps30d:     30
        case .fps47_952:  48
        case .fps48:      48
        case .fps50:      50
        case .fps59_94:   60
        case .fps59_94d:  60
        case .fps60:      60
        case .fps60d:     60
        case .fps95_904:  96
        case .fps96:      96
        case .fps100:     100
        case .fps119_88:  120
        case .fps119_88d: 120
        case .fps120:     120
        case .fps120d:    120
        }
    }
    
    /// Internal use.
    /// Constant used when calculating total frame count, audio samples, etc.
    package var frameRateForElapsedFramesCalculation: Double {
        switch self {
        case .fps23_976:  24.0
        case .fps24:      24.0
        case .fps24_98:   25.0
        case .fps25:      25.0
        case .fps29_97:   30.0
        case .fps29_97d:  29.97
        case .fps30:      30.0
        case .fps30d:     29.97
        case .fps47_952:  48.0
        case .fps48:      48.0
        case .fps50:      50.0
        case .fps59_94:   60.0
        case .fps59_94d:  59.94
        case .fps60:      60.0
        case .fps60d:     59.94
        case .fps95_904:  96.0
        case .fps96:      96.0
        case .fps100:     100.0
        case .fps119_88:  120.0
        case .fps119_88d: 119.88
        case .fps120:     120.0
        case .fps120d:    119.88
        }
    }
    
    /// Internal use.
    /// Constant used in real time conversion, SMF export, etc.
    package var frameRateForRealTimeCalculation: Double {
        switch self {
        case .fps23_976:  24.0 / 1.001
        case .fps24:      24.0
        case .fps24_98:   25.0 / 1.001
        case .fps25:      25.0
        case .fps29_97:   30.0 / 1.001
        case .fps29_97d:  30.0 / 1.001
        case .fps30:      30.0
        case .fps30d:     30.0
        case .fps47_952:  48.0 / 1.001
        case .fps48:      48.0
        case .fps50:      50.0
        case .fps59_94:   60.0 / 1.001
        case .fps59_94d:  60.0 / 1.001
        case .fps60:      60.0
        case .fps60d:     60.0
        case .fps95_904:  96.0 / 1.001
        case .fps96:      96.0
        case .fps100:     100.0
        case .fps119_88:  120.0 / 1.001
        case .fps119_88d: 120.0 / 1.001
        case .fps120:     120.0
        case .fps120d:    120.0
        }
    }
    
    /// Internal use.
    package var framesDroppedPerMinute: Double {
        switch self {
        case .fps29_97d:  2.0
        case .fps30d:     2.0
        case .fps59_94d:  4.0
        case .fps60d:     4.0
        case .fps119_88d: 8.0
        case .fps120d:    8.0
        case .fps23_976,
             .fps24,
             .fps24_98,
             .fps25,
             .fps29_97,
             .fps30,
             .fps47_952,
             .fps48,
             .fps50,
             .fps59_94,
             .fps60,
             .fps95_904,
             .fps96,
             .fps100,
             .fps119_88,
             .fps120:
            
            // this value is not actually used
            // this is only here so that when adding frame rates to the framework, the compiler will throw an error to remind you to add the
            // enum case here
            0.0
        }
    }
}
