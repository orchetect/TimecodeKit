//
//  FrameRateProtocol.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if canImport(CoreMedia)
import CoreMedia
#endif

public protocol FrameRateProtocol where
    Self: CaseIterable,
    AllCases.Index == Int,
    Self: Equatable
{
    // MARK: Properties
    
    /// Returns human-readable frame rate string.
    var stringValue: String { get }
    
    /// Initializes from a ``stringValue`` string. Case-sensitive.
    init?(stringValue: String)
    
    /// Returns the frame rate expressed as a rational number (fraction).
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled.
    var rate: Fraction { get }
    
    /// Returns the duration of 1 frame as a rational number (fraction).
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled.
    var frameDuration: Fraction { get }
    
    /// Returns an alternate duration of 1 frame as a rational number (fraction), if any.
    ///
    /// - Note: Drop frame is not embeddable in a fraction. If the frame rate is a timecode
    /// rate (and not a video rate), its status as a drop or non-drop rate must be stored
    /// independently and recalled.
    var alternateFrameDuration: Fraction? { get }
    
    #if canImport(CoreMedia)
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    var frameDurationCMTime: CMTime { get }
    #endif
}
