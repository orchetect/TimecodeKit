//
//  Timecode Real Time.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

extension Timecode {
	
	/// (Lossy) Returns the current timecode converted to a duration in real-time milliseconds (wall-clock time), based on the frame rate. Value is returned as a Double so a high level of precision can be maintained.
	///
	/// Generally, `.realTimeValue` -> `.setTimecode(from: TimeValue)` will produce equivalent results where 'from timecode' == 'out timecode'.
	/// When setting, invalid values will cause the setter to fail silently. (Validation is based on the frame rate and `upperLimit` property.)
	public var realTimeValue: TimeValue {
		
		get {
			var calc = Double(totalElapsedFrames) * (1000.0 / frameRate.frameRateForRealTimeCalculation)
			
			// over-estimate so real time is just past the equivalent timecode
			// so calculations of real time back into timecode work reliably
			// otherwise, this math produces a real time value that can be a hair under the actual elapsed real time that would trigger the equivalent timecode
			
			calc += 0.00001
			
			return TimeValue(ms: calc)
		}
		
		set {
			// set, suppressing failure silently
			_ = setTimecode(from: newValue)
		}
		
	}
	
	/// Sets the timecode to the nearest frame at the current frame rate from real-time milliseconds.
	/// Returns false if it underflows or overflows valid timecode range.
	@discardableResult
	public mutating func setTimecode(from realTimeValue: TimeValue) -> Bool {
		
		// the basic calculation
		var calc = realTimeValue.ms / (1000.0 / frameRate.frameRateForRealTimeCalculation)
		
		// over-estimate so real time is just past the equivalent timecode
		// so calculations of real time back into timecode work reliably
		// otherwise, this math produces a real time value that can be a hair under the actual elapsed real time that would trigger the equivalent timecode
		
		calc += 0.0006
		
		// final calculation
		
		let elapsedFrames = calc
		let convertedComponents = Self.components(from: elapsedFrames,
												  at: frameRate,
												  subFramesDivisor: subFramesDivisor)
		
		return setTimecode(exactly: convertedComponents)
		
	}
	
}

extension TimeValue {
	
	/// Convenience method to create an `Timecode` struct using the default `(_ exactly:)` initializer.
	public func toTimecode(at frameRate: Timecode.FrameRate,
						   limit: Timecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> Timecode? {
		
		if let sfd = subFramesDivisor {
			
			return Timecode(self,
							at: frameRate,
							limit: limit,
							subFramesDivisor: sfd)
			
		} else {
			
			return Timecode(self,
							at: frameRate,
							limit: limit)
			
		}
		
	}
	
}
