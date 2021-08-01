//
//  Deprecations.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

// MARK: - Data Interchange/Timecode Components.swift

extension Timecode.Components {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(at:limit:base:format:)")
    @inlinable public func toTimecode(
        at frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode?
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(rawValuesat:limit:base:format:)")
    @inlinable public func toTimecode(
        rawValuesAt frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Data Interchange/Timecode FrameCount.swift

extension Timecode {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(of:at:base:)")
    public static func frameCount(of values: Components,
                                  at frameRate: FrameRate,
                                  subFramesDivisor: Int? = nil) -> FrameCount
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(from:at:)")
    public static func components(from frameCount: FrameCount,
                                  at frameRate: FrameRate,
                                  subFramesDivisor: Int) -> Components
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Data Interchange/Timecode Real Time.swift

extension TimeInterval {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(at:limit:base:format:)")
    @inlinable public func toTimecode(
        at frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode?
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Data Interchange/Timecode String.swift

extension String {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(at:limit:base:format:)")
    @inlinable public func toTimecode(
        at frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode?
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "toTimecode(rawValuesat:limit:base:format:)")
    @inlinable public func toTimecode(
        rawValuesAt frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode?
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Formatter/TextFormatter.swift

extension Timecode.TextFormatter {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "stringFormat.showSubFrames")
    public var displaySubFrames: Bool?
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "subFramesBase.rawValue")
    public var subFramesDivisor: Int?
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(frameRate:limit:stringFormat:subFramesBase:showsValidation:validationAttributes:)")
    public convenience init(frameRate: Timecode.FrameRate? = nil,
                            limit: Timecode.UpperLimit? = nil,
                            displaySubFrames: Bool? = nil,
                            subFramesDivisor: Int? = nil,
                            showsValidation: Bool = false,
                            validationAttributes: [NSAttributedString.Key: Any]? = nil)
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - FrameCount/FrameCount.swift

extension Timecode.FrameCount {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "subFrames")
    public func subFrames(usingSubFramesDivisor: Int) -> Int
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "doubleValue")
    public func doubleValue(usingSubFramesDivisor: Int) -> Double
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "doubleValue")
    public func decimalValue(usingSubFramesDivisor: Int) -> Decimal
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(subFrameCount:base:)")
    internal init(totalElapsedSubFrames: Int,
                  usingSubFramesDivisor: Int)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "totalSubFrames")
    internal func totalSubFrames(usingSubFramesDivisor: Int) -> Int
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - FrameRate/FrameRate Properties.swift

extension Timecode.FrameRate {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "maxTotalSubFrames(in:base:)")
    public func maxTotalSubFrames(in extent: Timecode.UpperLimit,
                                  usingSubFramesDivisor: Int) -> Int
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "maxTotalSubFramesExpressible(in:base:)")
    public func maxTotalSubFramesExpressible(in extent: Timecode.UpperLimit,
                                             usingSubFramesDivisor: Int) -> Int
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Timecode Validation.swift

extension Timecode.Components {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "invalidComponents(at:limit:base:)")
    public func invalidComponents(at frameRate: Timecode.FrameRate,
                                  limit: Timecode.UpperLimit,
                                  subFramesDivisor: Int) -> Set<Timecode.Component>
    { fatalError() } // never runs but prevents compiler from complaining
    
}

extension Timecode {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "invalidComponents(in:at:limit:base:)")
    public static func invalidComponents(in components: TCC,
                                         at frameRate: FrameRate,
                                         limit: UpperLimit,
                                         subFramesDivisor: Int) -> Set<Component>
    { fatalError() } // never runs but prevents compiler from complaining
    
}

extension Timecode.Components {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "validRange(of:at:limit:base:)")
    public func validRange(of component: Timecode.Component,
                           at frameRate: Timecode.FrameRate,
                           limit: Timecode.UpperLimit,
                           subFramesDivisor: Int) -> (ClosedRange<Int>)
    { fatalError() } // never runs but prevents compiler from complaining
    
}

extension Timecode {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "maxFrameCountExpressibleDouble")
    public var maxFramesAndSubframesExpressibleDouble: Double
    { fatalError() } // never runs but prevents compiler from complaining
    
    
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "maxSubFrameCountExpressible")
    public var maxTotalSubframesExpressible: Int
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Timecode inits.swift

extension Timecode {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(at:limit:base:format:)")
    @inlinable public init(at frameRate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           subFramesDivisor: Int = 80,
                           displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(_:at:limit:base:format:)")
    @inlinable public init?(_ exactly: FrameCount,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(_:at:limit:base:format:)")
    @inlinable public init?(_ exactly: Components,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(clampingEach:at:limit:base:format:)")
    @inlinable public init(clamping source: Components,
                           at frameRate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           subFramesDivisor: Int = 80,
                           displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(wrapping:at:limit:base:format:)")
    @inlinable public init(wrapping source: Components,
                           at frameRate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           subFramesDivisor: Int = 80,
                           displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(rawValues:at:limit:base:format:)")
    @inlinable public init(rawValues source: Components,
                           at frameRate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           subFramesDivisor: Int = 80,
                           displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(_:at:limit:base:format:)")
    @inlinable public init?(_ exactly: String,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(clampingEach:at:limit:base:format:)")
    @inlinable public init?(clamping source: String,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(wrapping:at:limit:base:format:)")
    @inlinable public init?(wrapping source: String,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(rawValues:at:limit:base:format:)")
    @inlinable public init?(rawValues source: String,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(realTimeValue:at:limit:base:format:)")
    @inlinable public init?(realTimeValue source: TimeInterval,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "init(samples:sampleRate:at:limit:base:format:)")
    @inlinable public init?(samples source: Double,
                            sampleRate: Int,
                            at frameRate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            subFramesDivisor: Int = 80,
                            displaySubFrames: Bool = false)
    { fatalError() } // never runs but prevents compiler from complaining
    
}

// MARK: - Timecode.swift

extension Timecode {
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "stringFormat.showSubFrames")
    public var displaySubFrames: Bool
    { fatalError() } // never runs but prevents compiler from complaining
    
    /// Changed in TimecodeKit 1.2.1
    @available(swift, obsoleted: 0.1, renamed: "subFramesBase.rawValue")
    public var subFramesDivisor: Int
    { fatalError() } // never runs but prevents compiler from complaining
    
}
