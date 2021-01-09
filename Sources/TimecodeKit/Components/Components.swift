//
//  Components.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

/// Convenience typealias for cleaner code.
public typealias TCC = Timecode.Components

extension Timecode {
	
	/// Primitive struct describing timecode values, agnostic of frame rate.
	/// (The global typealias `TCC()` is also available for convenience.)
	///
	/// Raw values are stored and are not implicitly validated or clamped.
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

extension Timecode.Components: Equatable {
	
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		
		lhs.d == rhs.d &&
			lhs.h == rhs.h &&
			lhs.m == rhs.m &&
			lhs.s == rhs.s &&
			lhs.f == rhs.f &&
			lhs.sf == rhs.sf
		
	}
	
}

extension Timecode.Components {
	
	/// Returns an instance of `Timecode(exactly:)`.
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
	public func toTimecode(rawValuesAt frameRate: Timecode.FrameRate,
						   limit: Timecode.UpperLimit = ._24hours,
						   subFramesDivisor: Int? = nil) -> Timecode
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
