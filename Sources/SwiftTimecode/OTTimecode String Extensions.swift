//
//  OTTimecode String Extensions.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - to OTTimecode

extension String {
	
	/// Returns an instance of `OTTimecode(exactly:)`.
	/// If the string is not a valid timecode string, it returns nil.
	public func toTimecode(at frameRate: OTTimecode.FrameRate,
						   limit: OTTimecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> OTTimecode?
	{
		
		if let sfd = subFramesDivisor {
			
			return OTTimecode(self,
							  at: frameRate,
							  limit: limit,
							  subFramesDivisor: sfd)
			
		} else {
			
			return OTTimecode(self,
							  at: frameRate,
							  limit: limit)
			
		}
		
	}
	
	/// Returns an instance of `OTTimecode(rawValues:)`.
	/// If the string is not a valid timecode string, it returns nil.
	public func toTimecode(rawValuesAt frameRate: OTTimecode.FrameRate,
						   limit: OTTimecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> OTTimecode?
	{
		
		if let sfd = subFramesDivisor {
			
			return OTTimecode(rawValues: self,
							  at: frameRate,
							  limit: limit,
							  subFramesDivisor: sfd)
			
		} else {
			
			return OTTimecode(rawValues: self,
							  at: frameRate,
							  limit: limit)
			
		}
		
	}
	
}
