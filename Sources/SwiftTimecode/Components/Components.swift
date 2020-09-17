//
//  Components.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

/// Convenience typealias for cleaner code.
public typealias TCC = OTTimecode.Components

extension OTTimecode {
	
	/// Primitive struct that can contain timecode values, agnostic of frame rate.
	/// Raw values are stored and are not internally limited or clamped.
	/// The global typealias TCC() is also available for convenience.
	public struct Components {
		
		// MARK: Contents
		
		/// Days
		public var d: Int
		
		/// Hours
		public var h: Int
		
		/// Minutes
		public var m: Int
		
		/// Seconds
		public var s: Int
		
		/// Frames
		public var f: Int
		
		/// Subframe component (expressed as unit interval 0.0...1.0)
		public var sf: Int
		
		// MARK: init
		
		public init(d: Int = 0,
					h: Int = 0,
					m: Int = 0,
					s: Int = 0,
					f: Int = 0,
					sf: Int = 0)
		{
			self.d = d
			self.h = h
			self.m = m
			self.s = s
			self.f = f
			self.sf = sf
		}
		
	}
	
}

extension OTTimecode.Components: Equatable {
	
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.d == rhs.d &&
			lhs.h == rhs.h &&
			lhs.m == rhs.m &&
			lhs.s == rhs.s &&
			lhs.f == rhs.f &&
			lhs.sf == rhs.sf
	}
	
}

extension OTTimecode.Components {
	
	/// Returns an instance of `OTTimecode(exactly:)`.
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
