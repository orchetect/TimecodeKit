//
//  OTTimecode init.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension OTTimecode {
	
	// MARK: Basic
	
	/// Instance with default values.
	public init(at frameRate: FrameRate,
				limit: UpperLimit = ._24hours,
				subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
	}
	
	
	// MARK: Components
	
	/** Instance with timecode values and frame rate. Optionally set `upperLimit`.
	Values which are out-of-bounds will return nil.
	(Validation is based on the frame rate and `upperLimit` property.)
	*/
	public init?(_ exactly: Components,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(exactly: exactly) { return nil }
		
	}
	
	/** Instance with timecode values and frame rate. Optionally set `upperLimit`.
	Values which are out-of-bounds will be clamped to minimum or maximum possible values.
	(Clamping is based on the frame rate and `upperLimit` property.)
	*/
	public init(clamping: Components,
				at frameRate: FrameRate,
				limit: UpperLimit = ._24hours,
				subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(clamping: clamping)
		
	}
	
	/** Instance with timecode values and frame rate. Optionally set `upperLimit`.
	Timecodes will be wrapped around the timecode clock if out-of-bounds.
	(Wrapping is based on the frame rate and `upperLimit` property.)
	*/
	public init(wrapping: Components,
				at frameRate: FrameRate,
				limit: UpperLimit = ._24hours,
				subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(wrapping: wrapping)
		
	}
	
	/** Instance with timecode values and frame rate.
	Timecode values will not be validated or rejected if they overflow.
	*/
	public init(rawValues: Components,
				at frameRate: FrameRate,
				limit: UpperLimit = ._24hours,
				subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		setTimecode(rawValues: rawValues)
		
	}
	
	
	// MARK: String
	
	/** Instance with timecode string and frame rate. Optionally set `upperLimit`.
	An improperly formatted timecode string or one with invalid values will return nil.
	(Validation is based on the frame rate and `upperLimit` property.)
	*/
	public init?(_ exactly: String,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(exactly: exactly) { return nil }
		
	}
	
	/** Instance with timecode string and frame rate. Optionally set `upperLimit`.
	Values which are out-of-bounds will be clamped to minimum or maximum possible values.
	(Clamping is based on the frame rate and `upperLimit` property.)
	*/
	public init?(clamping: String,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(clamping: clamping) { return nil } // validation is triggered by this method
		
	}
	
	/** Instance with timecode string and frame rate. Optionally set `upperLimit`.
	An improperly formatted timecode string or one with invalid values will return nil.
	(Wrapping is based on the frame rate and `upperLimit` property.)
	*/
	public init?(wrapping: String,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(wrapping: wrapping) { return nil }
		
	}
	
	/** Instance with timecode values and frame rate.
	Timecode values will not be validated or rejected if they overflow.
	*/
	public init?(rawValues: String,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
		
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
		
		if !setTimecode(rawValues: rawValues) { return nil }
		
	}
	
	// MARK: Real time
	
	/// Instance with real time and frame rate. Optionally set `upperLimit`.
	public init?(_ lossy: OTTime,
				at frameRate: FrameRate,
				limit: UpperLimit = ._24hours,
				subFramesDivisor: Int = 80)
	{
	
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
	
		if !self.setTimecode(from: lossy) { return nil }
		
	}
	
	/// Instance with real time and frame rate. Optionally set `upperLimit`.
	public init?(samples: Double,
				 sampleRate: Int,
				 at frameRate: FrameRate,
				 limit: UpperLimit = ._24hours,
				 subFramesDivisor: Int = 80)
	{
	
		self.frameRate = frameRate
		self.upperLimit = limit
		self.subFramesDivisor = subFramesDivisor
	
		if !self.setTimecode(fromSamplesValue: samples, atSampleRate: sampleRate) { return nil }
		
	}
	
}
