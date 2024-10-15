//
//  FrameRateProtocol Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: Sorted

extension FrameRateProtocol {
    /// Internal: uses `allCases` to determine sort order.
    fileprivate var sortOrderIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

extension Collection where Element: FrameRateProtocol {
    /// Returns an array containing Elements logically sorted.
    public func sorted() -> [Element] {
        sorted { $0.sortOrderIndex < $1.sortOrderIndex }
    }
}

// MARK: Utils

extension Collection where Element: FrameRateProtocol {
    /// Internal:
    /// Filters collection to rates that match the given rational rate fraction.
    func filter(
        rate: Fraction
    ) -> [Element] {
        filter {
            let lhsFrac = $0.rate
            
            let isLiteralMatch = lhsFrac.numerator == rate.numerator
                && lhsFrac.denominator == rate.denominator
            
            let lhsFPS = Double(lhsFrac.numerator) / Double(lhsFrac.denominator)
            let rhsFPS = Double(rate.numerator) / Double(rate.denominator)
            let isFPSMatch = lhsFPS == rhsFPS
            
            return isLiteralMatch || isFPSMatch
        }
    }
    
    /// Internal:
    /// Filters collection to rates that match the given rational frame duration fraction.
    func filter(
        frameDuration: Fraction
    ) -> [Element] {
        filter {
            func compare(lhsFrac: Fraction, result: inout Bool) {
                let isLiteralMatch = lhsFrac.numerator == frameDuration.numerator
                    && lhsFrac.denominator == frameDuration.denominator
                if isLiteralMatch { result = true; return }
                
                let lhsFPS = Double(lhsFrac.numerator) / Double(lhsFrac.denominator)
                let rhsFPS = Double(frameDuration.numerator) / Double(frameDuration.denominator)
                let isFPSMatch = lhsFPS == rhsFPS
                if isFPSMatch { result = true; return }
            }
            
            var result = false
            
            // first check primary frame duration
            compare(lhsFrac: $0.frameDuration, result: &result)
            
            // then check alternate frame duration
            if let lhsFrac = $0.alternateFrameDuration {
                compare(lhsFrac: lhsFrac, result: &result)
            }
            
            return result
        }
    }
}

// MARK: - CMTime

#if canImport(CoreMedia)
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension FrameRateProtocol {
    // NOTE: Initializers that take CMTime rate/frameDuration are implemented on each concrete type that conforms to `FrameRateProtocol`.
    
    /// Returns the frame rate (fps) as a rational number (fraction)
    /// as a Core Media `CMTime` instance.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public var rateCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rate.numerator),
            timescale: CMTimeScale(rate.denominator)
        )
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a Core Media `CMTime` instance.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public var frameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(frameDuration.numerator),
            timescale: CMTimeScale(frameDuration.denominator)
        )
    }
}

#endif
