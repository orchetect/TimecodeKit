//
//  TimecodeFrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension TimecodeFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case ._23_976:      return "23.976"
        case ._24:          return "24"
        case ._24_98:       return "24.98"
        case ._25:          return "25"
        case ._29_97:       return "29.97"
        case ._29_97_drop:  return "29.97d"
        case ._30:          return "30"
        case ._30_drop:     return "30d"
        case ._47_952:      return "47.952"
        case ._48:          return "48"
        case ._50:          return "50"
        case ._59_94:       return "59.94"
        case ._59_94_drop:  return "59.94d"
        case ._60:          return "60"
        case ._60_drop:     return "60d"
        case ._95_904:      return "95.904"
        case ._96:          return "96"
        case ._100:         return "100"
        case ._119_88:      return "119.88"
        case ._119_88_drop: return "119.88d"
        case ._120:         return "120"
        case ._120_drop:    return "120d"
        }
    }
    
    /// Returns human-readable frame rate string in long form.
    public var stringValueVerbose: String {
        switch self {
        case ._23_976:      return "23.976 fps"
        case ._24:          return "24 fps"
        case ._24_98:       return "24.98 fps"
        case ._25:          return "25 fps"
        case ._29_97:       return "29.97 fps"
        case ._29_97_drop:  return "29.97 fps drop"
        case ._30:          return "30 fps"
        case ._30_drop:     return "30 fps drop"
        case ._47_952:      return "47.952 fps"
        case ._48:          return "48 fps"
        case ._50:          return "50 fps"
        case ._59_94:       return "59.94 fps"
        case ._59_94_drop:  return "59.94 fps drop"
        case ._60:          return "60 fps"
        case ._60_drop:     return "60 fps drop"
        case ._95_904:      return "95.904 fps"
        case ._96:          return "96 fps"
        case ._100:         return "100 fps"
        case ._119_88:      return "119.88 fps"
        case ._119_88_drop: return "119.88 fps drop"
        case ._120:         return "120 fps"
        case ._120_drop:    return "120 fps drop"
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
    ///     // == frame rate
    ///     Double(numerator) / Double(denominator)
    ///
    ///     // == duration of 1 frame in seconds
    ///     Double(denominator) / Double(numerator)
    public var rate: Fraction {
        switch self {
        case ._23_976:      return Fraction(24000,   1001)
        case ._24:          return Fraction(24,      1)
        case ._24_98:       return Fraction(25000,   1001)
        case ._25:          return Fraction(25,      1)
        case ._29_97:       return Fraction(30000,   1001)
        case ._29_97_drop:  return Fraction(30000,   1001)
        case ._30:          return Fraction(30,      1)
        case ._30_drop:     return Fraction(30,      1)
        case ._47_952:      return Fraction(48000,   1001)
        case ._48:          return Fraction(48,      1)
        case ._50:          return Fraction(50,      1)
        case ._59_94:       return Fraction(60000,   1001)
        case ._59_94_drop:  return Fraction(60000,   1001)
        case ._60:          return Fraction(60,      1)
        case ._60_drop:     return Fraction(60,      1)
        case ._95_904:      return Fraction(96000,   1001)
        case ._96:          return Fraction(96,      1)
        case ._100:         return Fraction(100,     1)
        case ._119_88:      return Fraction(120_000, 1001)
        case ._119_88_drop: return Fraction(120_000, 1001)
        case ._120:         return Fraction(120,     1)
        case ._120_drop:    return Fraction(120,     1)
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
        case ._23_976:      return Fraction(1001, 24000)
        case ._24:          return Fraction(100,  2400)
        case ._24_98:       return Fraction(1001, 25000) // TODO: inferred
        case ._25:          return Fraction(100,  2500)
        case ._29_97:       return Fraction(1001, 30000)
        case ._29_97_drop:  return Fraction(1001, 30000)
        case ._30:          return Fraction(100,  3000)
        case ._30_drop:     return Fraction(100,  3000) // TODO: needs checking
        case ._47_952:      return Fraction(1001, 48000) // TODO: inferred
        case ._48:          return Fraction(100,  4800)
        case ._50:          return Fraction(100,  5000)
        case ._59_94:       return Fraction(1001, 60000) // TODO: inferred
        case ._59_94_drop:  return Fraction(1001, 60000) // TODO: inferred
        case ._60:          return Fraction(100,  6000)
        case ._60_drop:     return Fraction(100,  6000) // TODO: needs checking
        case ._95_904:      return Fraction(1001, 96000) // TODO: inferred
        case ._96:          return Fraction(100,  9600) // TODO: inferred
        case ._100:         return Fraction(100,  10000)
        case ._119_88:      return Fraction(1001, 120000) // TODO: inferred
        case ._119_88_drop: return Fraction(1001, 120000) // TODO: inferred
        case ._120:         return Fraction(100,  12000)
        case ._120_drop:    return Fraction(100,  12000) // TODO: needs checking
        }
    }
    
    /// Alternate frame durations used, such as QuickTime timecode track.
    /// Some encoders errantly encode frame rate fractions,
    /// so we can fall back to these values a secondary checks.
    public var alternateFrameDuration: Fraction? {
        switch self {
        case ._23_976:      return Fraction(1000, 23976) // seen in the wild
        case ._24:          return nil
        case ._24_98:       return Fraction(1000, 24980) // TODO: inferred
        case ._25:          return nil
        case ._29_97:       return Fraction(1000, 29970) // seen in the wild
        case ._29_97_drop:  return Fraction(1000, 29970) // seen in the wild
        case ._30:          return nil
        case ._30_drop:     return nil // TODO: needs checking
        case ._47_952:      return Fraction(1000, 47952) // TODO: inferred
        case ._48:          return nil
        case ._50:          return nil
        case ._59_94:       return Fraction(1000, 59940) // TODO: inferred
        case ._59_94_drop:  return Fraction(1000, 59940) // TODO: inferred
        case ._60:          return nil
        case ._60_drop:     return nil // TODO: needs checking
        case ._95_904:      return Fraction(1000, 95904) // TODO: inferred
        case ._96:          return nil
        case ._100:         return nil
        case ._119_88:      return Fraction(1000, 119880) // TODO: inferred
        case ._119_88_drop: return Fraction(1000, 119880) // TODO: inferred
        case ._120:         return nil
        case ._120_drop:    return nil // TODO: needs checking
        }
    }
    
    /// Returns `true` if frame rate is drop.
    public var isDrop: Bool {
        switch self {
        case ._23_976:      return false
        case ._24:          return false
        case ._24_98:       return false
        case ._25:          return false
        case ._29_97:       return false
        case ._29_97_drop:  return true
        case ._30:          return false
        case ._30_drop:     return true
        case ._47_952:      return false
        case ._48:          return false
        case ._50:          return false
        case ._59_94:       return false
        case ._59_94_drop:  return true
        case ._60:          return false
        case ._60_drop:     return true
        case ._95_904:      return false
        case ._96:          return false
        case ._100:         return false
        case ._119_88:      return false
        case ._119_88_drop: return true
        case ._120:         return false
        case ._120_drop:    return true
        }
    }
    
    /// Returns the number of digits required for frames within the timecode string.
    ///
    /// ie: 24 or 30 fps would return 2, but 120 fps would return 3.
    public var numberOfDigits: Int {
        switch self {
        case ._23_976,
             ._24,
             ._24_98,
             ._25,
             ._29_97,
             ._29_97_drop,
             ._30,
             ._30_drop,
             ._47_952,
             ._48,
             ._50,
             ._59_94,
             ._59_94_drop,
             ._60,
             ._60_drop,
             ._95_904,
             ._96,
             ._100:
            
            return 2
            
        case ._119_88,
             ._119_88_drop,
             ._120,
             ._120_drop:
            
            return 3
        }
    }
    
    /// Max frame number displayable before seconds roll over.
    public var maxFrameNumberDisplayable: Int {
        maxFrames - 1
    }
    
    /// Returns max total frames from 0 to and including rolling over to `extent`.
    public func maxTotalFrames(in extent: Timecode.UpperLimit) -> Int {
        switch extent {
        case ._24hours:
            switch self {
            case ._23_976:      return 2_073_600  // @ 24hours
            case ._24:          return 2_073_600  // @ 24hours
            case ._24_98:       return 2_160_000  // @ 24hours
            case ._25:          return 2_160_000  // @ 24hours
            case ._29_97:       return 2_592_000  // @ 24hours
            case ._29_97_drop:  return 2_589_408  // @ 24hours
            case ._30:          return 2_592_000  // @ 24hours
            case ._30_drop:     return 2_589_408  // @ 24hours
            case ._47_952:      return 4_147_200  // @ 24hours
            case ._48:          return 4_147_200  // @ 24hours
            case ._50:          return 4_320_000  // @ 24hours
            case ._59_94:       return 5_184_000  // @ 24hours (._29_97 * 2 in theory)
            case ._59_94_drop:  return 5_178_816  // @ 24hours (._29_97_drop * 2, in theory)
            case ._60:          return 5_184_000  // @ 24hours
            case ._60_drop:     return 5_178_816  // @ 24hours
            case ._95_904:      return 8_294_400  // @ 24hours
            case ._96:          return 8_294_400  // @ 24hours
            case ._100:         return 8_640_000  // @ 24hours
            case ._119_88:      return 10_368_000 // @ 24hours (._29_97 * 4 in theory)
            case ._119_88_drop: return 10_357_632 // @ 24hours (._29_97_drop * 4, in theory)
            case ._120:         return 10_368_000 // @ 24hours
            case ._120_drop:    return 10_357_632 // @ 24hours
            }
            
        case ._100days:
            return maxTotalFrames(in: ._24hours) * extent.maxDays
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
    internal var maxFrames: Int {
        switch self {
        case ._23_976:      return 24
        case ._24:          return 24
        case ._24_98:       return 25
        case ._25:          return 25
        case ._29_97:       return 30
        case ._29_97_drop:  return 30
        case ._30:          return 30
        case ._30_drop:     return 30
        case ._47_952:      return 48
        case ._48:          return 48
        case ._50:          return 50
        case ._59_94:       return 60
        case ._59_94_drop:  return 60
        case ._60:          return 60
        case ._60_drop:     return 60
        case ._95_904:      return 96
        case ._96:          return 96
        case ._100:         return 100
        case ._119_88:      return 120
        case ._119_88_drop: return 120
        case ._120:         return 120
        case ._120_drop:    return 120
        }
    }
    
    /// Internal use.
    /// Constant used when calculating total frame count, audio samples, etc.
    internal var frameRateForElapsedFramesCalculation: Double {
        switch self {
        case ._23_976:      return 24.0
        case ._24:          return 24.0
        case ._24_98:       return 25.0
        case ._25:          return 25.0
        case ._29_97:       return 30.0
        case ._29_97_drop:  return 29.97
        case ._30:          return 30.0
        case ._30_drop:     return 29.97
        case ._47_952:      return 48.0
        case ._48:          return 48.0
        case ._50:          return 50.0
        case ._59_94:       return 60.0
        case ._59_94_drop:  return 59.94
        case ._60:          return 60.0
        case ._60_drop:     return 59.94
        case ._95_904:      return 96.0
        case ._96:          return 96.0
        case ._100:         return 100.0
        case ._119_88:      return 120.0
        case ._119_88_drop: return 119.88
        case ._120:         return 120.0
        case ._120_drop:    return 119.88
        }
    }
    
    /// Internal use.
    /// Constant used in real time conversion, SMF export, etc.
    internal var frameRateForRealTimeCalculation: Double {
        switch self {
        case ._23_976:      return 24.0 / 1.001
        case ._24:          return 24.0
        case ._24_98:       return 25.0 / 1.001
        case ._25:          return 25.0
        case ._29_97:       return 30.0 / 1.001
        case ._29_97_drop:  return 30.0 / 1.001
        case ._30:          return 30.0
        case ._30_drop:     return 30.0
        case ._47_952:      return 48.0 / 1.001
        case ._48:          return 48.0
        case ._50:          return 50.0
        case ._59_94:       return 60.0 / 1.001
        case ._59_94_drop:  return 60.0 / 1.001
        case ._60:          return 60.0
        case ._60_drop:     return 60.0
        case ._95_904:      return 96.0 / 1.001
        case ._96:          return 96.0
        case ._100:         return 100.0
        case ._119_88:      return 120.0 / 1.001
        case ._119_88_drop: return 120.0 / 1.001
        case ._120:         return 120.0
        case ._120_drop:    return 120.0
        }
    }
    
    /// Internal use.
    internal var framesDroppedPerMinute: Double {
        switch self {
        case ._29_97_drop:  return 2.0
        case ._30_drop:     return 2.0
        case ._59_94_drop:  return 4.0
        case ._60_drop:     return 4.0
        case ._119_88_drop: return 8.0
        case ._120_drop:    return 8.0
            
        case ._23_976,
             ._24,
             ._24_98,
             ._25,
             ._29_97,
             ._30,
             ._47_952,
             ._48,
             ._50,
             ._59_94,
             ._60,
             ._95_904,
             ._96,
             ._100,
             ._119_88,
             ._120:
            
            // this value is not actually used
            // this is only here so that when adding frame rates to the framework, the compiler will throw an error to remind you to add the enum case here
            return 0.0
        }
    }
}
