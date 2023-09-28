//
//  TimecodeFrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension TimecodeFrameRate {
    /// Returns human-readable frame rate string.
    public var stringValue: String {
        switch self {
        case .fps23_976:  return "23.976"
        case .fps24:      return "24"
        case .fps24_98:   return "24.98"
        case .fps25:      return "25"
        case .fps29_97:   return "29.97"
        case .fps29_97d:  return "29.97d"
        case .fps30:      return "30"
        case .fps30d:     return "30d"
        case .fps47_952:  return "47.952"
        case .fps48:      return "48"
        case .fps50:      return "50"
        case .fps59_94:   return "59.94"
        case .fps59_94d:  return "59.94d"
        case .fps60:      return "60"
        case .fps60d:     return "60d"
        case .fps95_904:  return "95.904"
        case .fps96:      return "96"
        case .fps100:     return "100"
        case .fps119_88:  return "119.88"
        case .fps119_88d: return "119.88d"
        case .fps120:     return "120"
        case .fps120d:    return "120d"
        }
    }
    
    /// Returns human-readable frame rate string in long form.
    public var stringValueVerbose: String {
        switch self {
        case .fps23_976:  return "23.976 fps"
        case .fps24:      return "24 fps"
        case .fps24_98:   return "24.98 fps"
        case .fps25:      return "25 fps"
        case .fps29_97:   return "29.97 fps"
        case .fps29_97d:  return "29.97 fps drop"
        case .fps30:      return "30 fps"
        case .fps30d:     return "30 fps drop"
        case .fps47_952:  return "47.952 fps"
        case .fps48:      return "48 fps"
        case .fps50:      return "50 fps"
        case .fps59_94:   return "59.94 fps"
        case .fps59_94d:  return "59.94 fps drop"
        case .fps60:      return "60 fps"
        case .fps60d:     return "60 fps drop"
        case .fps95_904:  return "95.904 fps"
        case .fps96:      return "96 fps"
        case .fps100:     return "100 fps"
        case .fps119_88:  return "119.88 fps"
        case .fps119_88d: return "119.88 fps drop"
        case .fps120:     return "120 fps"
        case .fps120d:    return "120 fps drop"
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
        case .fps23_976:  return Fraction(24000,   1001)
        case .fps24:      return Fraction(24,      1)
        case .fps24_98:   return Fraction(25000,   1001)
        case .fps25:      return Fraction(25,      1)
        case .fps29_97:   return Fraction(30000,   1001)
        case .fps29_97d:  return Fraction(30000,   1001)
        case .fps30:      return Fraction(30,      1)
        case .fps30d:     return Fraction(30,      1)
        case .fps47_952:  return Fraction(48000,   1001)
        case .fps48:      return Fraction(48,      1)
        case .fps50:      return Fraction(50,      1)
        case .fps59_94:   return Fraction(60000,   1001)
        case .fps59_94d:  return Fraction(60000,   1001)
        case .fps60:      return Fraction(60,      1)
        case .fps60d:     return Fraction(60,      1)
        case .fps95_904:  return Fraction(96000,   1001)
        case .fps96:      return Fraction(96,      1)
        case .fps100:     return Fraction(100,     1)
        case .fps119_88:  return Fraction(120_000, 1001)
        case .fps119_88d: return Fraction(120_000, 1001)
        case .fps120:     return Fraction(120,     1)
        case .fps120d:    return Fraction(120,     1)
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
        case .fps23_976:  return Fraction(1001, 24000)
        case .fps24:      return Fraction(100,  2400)
        case .fps24_98:   return Fraction(1001, 25000) // TODO: inferred
        case .fps25:      return Fraction(100,  2500)
        case .fps29_97:   return Fraction(1001, 30000)
        case .fps29_97d:  return Fraction(1001, 30000)
        case .fps30:      return Fraction(100,  3000)
        case .fps30d:     return Fraction(100,  3000) // TODO: needs checking
        case .fps47_952:  return Fraction(1001, 48000) // TODO: inferred
        case .fps48:      return Fraction(100,  4800)
        case .fps50:      return Fraction(100,  5000)
        case .fps59_94:   return Fraction(1001, 60000) // TODO: inferred
        case .fps59_94d:  return Fraction(1001, 60000) // TODO: inferred
        case .fps60:      return Fraction(100,  6000)
        case .fps60d:     return Fraction(100,  6000) // TODO: needs checking
        case .fps95_904:  return Fraction(1001, 96000) // TODO: inferred
        case .fps96:      return Fraction(100,  9600) // TODO: inferred
        case .fps100:     return Fraction(100,  10000)
        case .fps119_88:  return Fraction(1001, 120000) // TODO: inferred
        case .fps119_88d: return Fraction(1001, 120000) // TODO: inferred
        case .fps120:     return Fraction(100,  12000)
        case .fps120d:    return Fraction(100,  12000) // TODO: needs checking
        }
    }
    
    /// Alternate frame durations used, such as QuickTime timecode track.
    /// Some encoders errantly encode frame rate fractions,
    /// so we can fall back to these values a secondary checks.
    public var alternateFrameDuration: Fraction? {
        switch self {
        case .fps23_976:  return Fraction(1000, 23976) // seen in the wild
        case .fps24:      return nil
        case .fps24_98:   return Fraction(1000, 24980) // TODO: inferred
        case .fps25:      return nil
        case .fps29_97:   return Fraction(1000, 29970) // seen in the wild
        case .fps29_97d:  return Fraction(1000, 29970) // seen in the wild
        case .fps30:      return nil
        case .fps30d:     return nil // TODO: needs checking
        case .fps47_952:  return Fraction(1000, 47952) // TODO: inferred
        case .fps48:      return nil
        case .fps50:      return nil
        case .fps59_94:   return Fraction(1000, 59940) // TODO: inferred
        case .fps59_94d:  return Fraction(1000, 59940) // TODO: inferred
        case .fps60:      return nil
        case .fps60d:     return nil // TODO: needs checking
        case .fps95_904:  return Fraction(1000, 95904) // TODO: inferred
        case .fps96:      return nil
        case .fps100:     return nil
        case .fps119_88:  return Fraction(1000, 119880) // TODO: inferred
        case .fps119_88d: return Fraction(1000, 119880) // TODO: inferred
        case .fps120:     return nil
        case .fps120d:    return nil // TODO: needs checking
        }
    }
    
    /// Returns `true` if frame rate is drop.
    public var isDrop: Bool {
        switch self {
        case .fps23_976:  return false
        case .fps24:      return false
        case .fps24_98:   return false
        case .fps25:      return false
        case .fps29_97:   return false
        case .fps29_97d:  return true
        case .fps30:      return false
        case .fps30d:     return true
        case .fps47_952:  return false
        case .fps48:      return false
        case .fps50:      return false
        case .fps59_94:   return false
        case .fps59_94d:  return true
        case .fps60:      return false
        case .fps60d:     return true
        case .fps95_904:  return false
        case .fps96:      return false
        case .fps100:     return false
        case .fps119_88:  return false
        case .fps119_88d: return true
        case .fps120:     return false
        case .fps120d:    return true
        }
    }
    
    /// Returns the number of digits required for frames within the timecode string.
    ///
    /// ie: 24 or 30 fps would return 2, but 120 fps would return 3.
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
            
            return 2
            
        case .fps119_88,
             .fps119_88d,
             .fps120,
             .fps120d:
            
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
        case .max24Hours:
            switch self {
            case .fps23_976:  return 2_073_600  // @ 24hours
            case .fps24:      return 2_073_600  // @ 24hours
            case .fps24_98:   return 2_160_000  // @ 24hours
            case .fps25:      return 2_160_000  // @ 24hours
            case .fps29_97:   return 2_592_000  // @ 24hours
            case .fps29_97d:  return 2_589_408  // @ 24hours
            case .fps30:      return 2_592_000  // @ 24hours
            case .fps30d:     return 2_589_408  // @ 24hours
            case .fps47_952:  return 4_147_200  // @ 24hours
            case .fps48:      return 4_147_200  // @ 24hours
            case .fps50:      return 4_320_000  // @ 24hours
            case .fps59_94:   return 5_184_000  // @ 24hours (.fps29_97 * 2 in theory)
            case .fps59_94d:  return 5_178_816  // @ 24hours (.fps29_97d * 2, in theory)
            case .fps60:      return 5_184_000  // @ 24hours
            case .fps60d:     return 5_178_816  // @ 24hours
            case .fps95_904:  return 8_294_400  // @ 24hours
            case .fps96:      return 8_294_400  // @ 24hours
            case .fps100:     return 8_640_000  // @ 24hours
            case .fps119_88:  return 10_368_000 // @ 24hours (.fps29_97 * 4 in theory)
            case .fps119_88d: return 10_357_632 // @ 24hours (.fps29_97d * 4, in theory)
            case .fps120:     return 10_368_000 // @ 24hours
            case .fps120d:    return 10_357_632 // @ 24hours
            }
            
        case .max100Days:
            return maxTotalFrames(in: .max24Hours) * extent.maxDays
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
    var maxFrames: Int {
        switch self {
        case .fps23_976:  return 24
        case .fps24:      return 24
        case .fps24_98:   return 25
        case .fps25:      return 25
        case .fps29_97:   return 30
        case .fps29_97d:  return 30
        case .fps30:      return 30
        case .fps30d:     return 30
        case .fps47_952:  return 48
        case .fps48:      return 48
        case .fps50:      return 50
        case .fps59_94:   return 60
        case .fps59_94d:  return 60
        case .fps60:      return 60
        case .fps60d:     return 60
        case .fps95_904:  return 96
        case .fps96:      return 96
        case .fps100:     return 100
        case .fps119_88:  return 120
        case .fps119_88d: return 120
        case .fps120:     return 120
        case .fps120d:    return 120
        }
    }
    
    /// Internal use.
    /// Constant used when calculating total frame count, audio samples, etc.
    var frameRateForElapsedFramesCalculation: Double {
        switch self {
        case .fps23_976:  return 24.0
        case .fps24:      return 24.0
        case .fps24_98:   return 25.0
        case .fps25:      return 25.0
        case .fps29_97:   return 30.0
        case .fps29_97d:  return 29.97
        case .fps30:      return 30.0
        case .fps30d:     return 29.97
        case .fps47_952:  return 48.0
        case .fps48:      return 48.0
        case .fps50:      return 50.0
        case .fps59_94:   return 60.0
        case .fps59_94d:  return 59.94
        case .fps60:      return 60.0
        case .fps60d:     return 59.94
        case .fps95_904:  return 96.0
        case .fps96:      return 96.0
        case .fps100:     return 100.0
        case .fps119_88:  return 120.0
        case .fps119_88d: return 119.88
        case .fps120:     return 120.0
        case .fps120d:    return 119.88
        }
    }
    
    /// Internal use.
    /// Constant used in real time conversion, SMF export, etc.
    var frameRateForRealTimeCalculation: Double {
        switch self {
        case .fps23_976:  return 24.0 / 1.001
        case .fps24:      return 24.0
        case .fps24_98:   return 25.0 / 1.001
        case .fps25:      return 25.0
        case .fps29_97:   return 30.0 / 1.001
        case .fps29_97d:  return 30.0 / 1.001
        case .fps30:      return 30.0
        case .fps30d:     return 30.0
        case .fps47_952:  return 48.0 / 1.001
        case .fps48:      return 48.0
        case .fps50:      return 50.0
        case .fps59_94:   return 60.0 / 1.001
        case .fps59_94d:  return 60.0 / 1.001
        case .fps60:      return 60.0
        case .fps60d:     return 60.0
        case .fps95_904:  return 96.0 / 1.001
        case .fps96:      return 96.0
        case .fps100:     return 100.0
        case .fps119_88:  return 120.0 / 1.001
        case .fps119_88d: return 120.0 / 1.001
        case .fps120:     return 120.0
        case .fps120d:    return 120.0
        }
    }
    
    /// Internal use.
    var framesDroppedPerMinute: Double {
        switch self {
        case .fps29_97d:  return 2.0
        case .fps30d:     return 2.0
        case .fps59_94d:  return 4.0
        case .fps60d:     return 4.0
        case .fps119_88d: return 8.0
        case .fps120d:    return 8.0
            
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
            return 0.0
        }
    }
}
