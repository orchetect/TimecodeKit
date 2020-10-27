//
//  Timecode.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-08.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation


/// Object representing SMPTE timecode data with a variety of number- and string- based constructors, including helper functions to convert between them operators to perform math operations between them.
public struct Timecode {
	
	// MARK: - Immutable properties
	
	/// Frame rate.
	///
	/// Note: Several properties are available on the frame rate that is selected, including its `.stringValue` representation or whether the rate `.isDrop`.
	///
	/// Setting this value directly does not trigger any validation.
	public let frameRate: FrameRate
	
	/// Timecode maximum upper bound.
	///
	/// This also affects how timecode values wrap when adding or clamping.
	///
	/// Setting this value directly does not trigger any validation.
	public let upperLimit: UpperLimit
	
	/// Subframes divisor.
	///
	/// The number of subframes that make up a single frame.
	///
	/// (ie: a divisor of 80 implies a range of 0...79)
	///
	/// This will vary depending on application. Most common divisors are 80 or 100.
	public let subFramesDivisor: Int
	
	/// Determines whether subframes are included when getting `.stringValue`.
	///
	/// This does not disable subframes from being stored or calculated, only whether they are output in the string.
	public var displaySubFrames: Bool = false
	
	// MARK: - Mutable properties
	
	/// Timecode days.
	///
	/// Valid only if `.upperLimit` is set to `._100days`.
	///
	/// Setting this value directly does not trigger any validation.
	public var days: Int = 0
	
	/// Timecode hours.
	///
	/// Valid range: 0-23.
	///
	/// Setting this value directly does not trigger any validation.
	public var hours: Int = 0
	
	/// Timecode minutes.
	///
	/// Valid range: 0-59.
	///
	/// Setting this value directly does not trigger any validation.
	public var minutes: Int = 0
	
	/// Timecode seconds.
	///
	/// Valid range: 0-59.
	///
	/// Setting this value directly does not trigger any validation.
	public var seconds: Int = 0
	
	/// Timecode frames.
	///
	/// Valid range is dependent on the `frameRate` property (0-23 for 24NDF, 0-29 for 30NDF, 2-29 every minute except 0-29 for every 10th minute for 29.97DF, etc.).
	///
	/// Setting this value directly does not trigger any validation.
	public var frames: Int = 0
	
	/// Timecode subframe component.
	///
	/// (ie: traditionally Cubase/Nuendo and Logic Pro use 80 subframes per frame, Pro Tools uses 100 subframes, etc.)
	///
	/// Setting this value directly does not trigger any validation.
	public var subFrames: Int = 0
	
}
