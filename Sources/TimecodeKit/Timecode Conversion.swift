//
//  Timecode Conversion.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-10-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.

import Foundation

extension Timecode {
	/// Return a new `Timecode` object converted to a new frame rate, based on real time.
	/// Note: this process may be lossy.
	public func converted(to frameRate: FrameRate) -> Timecode? {
		// convert to new frame rate, retaining all ancillary property values

		var newTC =
			Timecode(realTimeValue,
					 at: frameRate,
					 limit: upperLimit,
					 subFramesDivisor: subFramesDivisor)

		newTC?.displaySubFrames = displaySubFrames

		return newTC
	}
}
