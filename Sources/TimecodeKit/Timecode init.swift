//
//  Timecode init.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

extension Timecode {
	
	// MARK: Basic
	
	/// Instance with default timecode (00:00:00:00) at a given frame rate.
	@inlinable public init(at frameRate: FrameRate,
						   limit: UpperLimit = ._24hours,
						   subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
	}
	
	
	// MARK: Components
	
	/// Instance exactly from timecode values and frame rate.
	///
	/// If any values are out-of-bounds `nil` will be returned, indicating an invalid timecode.
	///
	/// Validation is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.
	@inlinable public init?(_ exactly: Components,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(exactly: exactly) { return nil }
		
	}
	
	/// Instance from timecode values and frame rate, clamping values if necessary.
	///
	/// Values which are out-of-bounds will be clamped to minimum or maximum possible values.
	///
	/// Clamping is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.
	@inlinable public init(clamping: Components,
						   at frameRate: FrameRate,
						   limit: UpperLimit = ._24hours,
						   subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(clamping: clamping)
		
	}
	
	/// Instance from timecode values and frame rate, wrapping timecode if necessary.
	///
	/// Timecodes will be wrapped around the timecode clock if out-of-bounds.
	///
	/// Wrapping is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.
	@inlinable public init(wrapping: Components,
						   at frameRate: FrameRate,
						   limit: UpperLimit = ._24hours,
						   subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(wrapping: wrapping)
		
	}
	
	/// Instance from raw timecode values and frame rate.
	///
	/// Timecode values will not be validated or rejected if they overflow.
	/// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
	@inlinable public init(rawValues: Components,
						   at frameRate: FrameRate,
						   limit: UpperLimit = ._24hours,
						   subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(rawValues: rawValues)
		
	}
	
	
	// MARK: String
	
	/// Instance exactly from timecode string and frame rate.
	///
	/// An improperly formatted timecode string or one with out-of-bounds values will return `nil`.
	///
	/// Validation is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.
	@inlinable public init?(_ exactly: String,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(exactly: exactly) { return nil }
		
	}
	
	/// Instance from timecode string and frame rate, clamping if values necessary.
	///
	/// Values which are out-of-bounds will be clamped to minimum or maximum possible values.
	/// (Clamping is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.)
	@inlinable public init?(clamping: String,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(clamping: clamping) { return nil }
		
	}
	
	/// Instance from timecode string and frame rate, wrapping timecode if necessary.
	///
	/// An improperly formatted timecode string or one with invalid values will return `nil`.
	///
	/// Wrapping is based on the frame rate and `upperLimit` property, as well as `subFrameDivisor` if subframes are non-zero.
	@inlinable public init?(wrapping: String,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(wrapping: wrapping) { return nil }
		
	}
	
	/// Instance from raw timecode values formatted as a timecode string and frame rate.
	///
	/// Timecode values will not be validated or rejected if they overflow.
	/// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
	@inlinable public init?(rawValues: String,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(rawValues: rawValues) { return nil }
		
	}
	
	// MARK: Real time
	
	/// Instance from real time and frame rate.
	///
	/// Note: this may be lossy.
	@inlinable public init?(_ lossy: TimeValue,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !self.setTimecode(from: lossy) { return nil }
		
	}
	
	/// Instance from real time and frame rate.
	///
	/// Note: this may be lossy.
	@inlinable public init?(samples: Double,
							sampleRate: Int,
							at frameRate: FrameRate,
							limit: UpperLimit = ._24hours,
							subFramesDivisor: Int = 80) {
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !self.setTimecode(fromSamplesValue: samples,
							 atSampleRate: sampleRate) { return nil }
		
	}
	
}
