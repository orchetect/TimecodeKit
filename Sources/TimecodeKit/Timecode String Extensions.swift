//
//  Timecode String Extensions.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - to Timecode

extension String {
	
	/// Returns an instance of `Timecode(exactly:)`.
	/// If the string is not a valid timecode string, it returns nil.
	public func toTimecode(at frameRate: Timecode.FrameRate,
						   limit: Timecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> Timecode?
	{
		
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
	
	/// Returns an instance of `Timecode(rawValues:)`.
	/// If the string is not a valid timecode string, it returns nil.
	public func toTimecode(rawValuesAt frameRate: Timecode.FrameRate,
						   limit: Timecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> Timecode?
	{
		
		if let sfd = subFramesDivisor {
			
			return Timecode(rawValues: self,
							at: frameRate,
							limit: limit,
							subFramesDivisor: sfd)
			
		} else {
			
			return Timecode(rawValues: self,
							at: frameRate,
							limit: limit)
			
		}
		
	}
	
}
