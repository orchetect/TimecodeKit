//
//  FrameRate Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: stringValue

extension Timecode.FrameRate {
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
        case ._100:         return "100 fps"
        case ._119_88:      return "119.88 fps"
        case ._119_88_drop: return "119.88 fps drop"
        case ._120:         return "120 fps"
        case ._120_drop:    return "120 fps drop"
        }
    }
    
    /// Initializes from a `stringValue` string. Case-sensitive.
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

extension Timecode.FrameRate {
    /// Returns the frame rate expressed as a fraction.
    ///
    ///     // == frame rate
    ///     Double(numerator) / Double(denominator)
    ///
    ///     // == duration of 1 frame in seconds
    ///     Double(denominator) / Double(numerator)
    public var fraction: (numerator: Int, denominator: Int) {
        switch self {
        case ._23_976:      return (numerator: 24000,   denominator: 1001)
        case ._24:          return (numerator: 24,      denominator: 1)
        case ._24_98:       return (numerator: 25000,   denominator: 1001)
        case ._25:          return (numerator: 25,      denominator: 1)
        case ._29_97:       return (numerator: 30000,   denominator: 1001)
        case ._29_97_drop:  return (numerator: 30000,   denominator: 1001)
        case ._30:          return (numerator: 30,      denominator: 1)
        case ._30_drop:     return (numerator: 30,      denominator: 1)
        case ._47_952:      return (numerator: 48000,   denominator: 1001)
        case ._48:          return (numerator: 48,      denominator: 1)
        case ._50:          return (numerator: 50,      denominator: 1)
        case ._59_94:       return (numerator: 60000,   denominator: 1001)
        case ._59_94_drop:  return (numerator: 60000,   denominator: 1001)
        case ._60:          return (numerator: 60,      denominator: 1)
        case ._60_drop:     return (numerator: 60,      denominator: 1)
        case ._100:         return (numerator: 100,     denominator: 1)
        case ._119_88:      return (numerator: 120_000, denominator: 1001)
        case ._119_88_drop: return (numerator: 120_000, denominator: 1001)
        case ._120:         return (numerator: 120,     denominator: 1)
        case ._120_drop:    return (numerator: 120,     denominator: 1)
        }
    }
    
    /// Returns true if frame rate is drop.
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

extension Timecode.FrameRate {
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
             ._100,
             ._119_88,
             ._120:
            
            // this value is not actually used
            // this is only here so that when adding frame rates to the framework, the compiler will throw an error to remind you to add the enum case here
            return 0.0
        }
    }
}
