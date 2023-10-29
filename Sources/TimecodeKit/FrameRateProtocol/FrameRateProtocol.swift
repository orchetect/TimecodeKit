//
//  FrameRateProtocol.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol used in TimecodeKit to provide shared properties and methods for frame rate types.
public protocol FrameRateProtocol where
    Self: CaseIterable,
    AllCases.Index == Int,
    Self: Equatable,
    Self: Sendable
{
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
}
