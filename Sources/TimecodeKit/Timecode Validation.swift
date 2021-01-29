//
//  Timecode Validation.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

@_implementationOnly import OTCore

extension Timecode {
	
	/// Returns a set of invalid components, if any.
	/// A fully valid timecode will return an empty set.
	/// Validation relies on `frameRate` and `upperLimit`.
	public var invalidComponents: Set<Component>
	{
		
		Self.invalidComponents(in: self.components,
							   at: frameRate,
							   limit: upperLimit,
							   subFramesDivisor: subFramesDivisor)
		
	}
	
}

extension Timecode.Components {
	
	/// Returns a set of invalid components, if any.
	/// A fully valid timecode will return an empty set.
	public func invalidComponents(at frameRate: Timecode.FrameRate,
								  limit: Timecode.UpperLimit,
								  subFramesDivisor: Int) -> Set<Timecode.Component>
	{
		
		Timecode.invalidComponents(in: self,
									 at: frameRate,
									 limit: limit,
									 subFramesDivisor: subFramesDivisor)
		
	}
	
}

extension Timecode {
	
	/// Returns a set of invalid components, if any.
	/// A fully valid timecode will return an empty set.
	public static func invalidComponents(in components: TCC,
										 at frameRate: FrameRate,
										 limit: UpperLimit,
										 subFramesDivisor: Int) -> Set<Component>
	{
		
		var invalids: Set<Component> = []
		
		// days
		
		if !components.validRange(of: .days,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.d)
		{ invalids.insert(.days) }
		
		// hours
		
		if !components.validRange(of: .hours,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.h)
		{ invalids.insert(.hours) }
		
		// minutes
		
		if !components.validRange(of: .minutes,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.m)
		{ invalids.insert(.minutes) }
		
		// seconds
		
		if !components.validRange(of: .seconds,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.s)
		{ invalids.insert(.seconds) }
		
		// frames
		
		if !components.validRange(of: .frames,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.f)
		{ invalids.insert(.frames) }
		
		// subframes
		
		if !components.validRange(of: .subFrames,
								  at: frameRate,
								  limit: limit,
								  subFramesDivisor: subFramesDivisor)
			.contains(components.sf)
		{ invalids.insert(.subFrames) }
		
		return invalids
		
	}
	
}

extension Timecode {
	
	/// Returns valid range of values for a timecdoe component, given the current `frameRate` and `upperLimit`.
	@inlinable public func validRange(of component: Component) -> (ClosedRange<Int>)
	{
		
		components.validRange(of: component,
							  at: frameRate,
							  limit: upperLimit,
							  subFramesDivisor: subFramesDivisor)
		
	}
	
}

extension Timecode.Components {
	
	/// Returns valid range of values for a timecdoe component.
	public func validRange(of component: Timecode.Component,
						   at frameRate: Timecode.FrameRate,
						   limit: Timecode.UpperLimit,
						   subFramesDivisor: Int) -> (ClosedRange<Int>)
	{
		
		switch component {
			
		case .days:
			return 0...limit.maxDaysExpressible
			
		case .hours:
			return 0...23
			
		case .minutes:
			return 0...59
			
		case .seconds:
			return 0...59
			
		case .frames:
			let startFramePossible = frameRate.isDrop
				? ((m % 10 != 0 && s == 0) ? 2 : 0)
				: 0
			
			return startFramePossible...frameRate.maxFrameNumberDisplayable
			
		case .subFrames:
			// clamp divisor to prevent a possible crash if subFramesDivisor < 0
			return 0...(subFramesDivisor.clamped(to: 1...) - 1)
			
		}
		
	}
	
}

extension Timecode {
	
	internal mutating func __clamp(component: Component) {
		
		switch component {
		case .days:
			days = days.clamped(to: validRange(of: .days))
			
		case .hours:
			hours = hours.clamped(to: validRange(of: .hours))
			
		case .minutes:
			minutes = minutes.clamped(to: validRange(of: .minutes))
			
		case .seconds:
			seconds = seconds.clamped(to: validRange(of: .seconds))
			
		case .frames:
			frames = frames.clamped(to: validRange(of: .frames))
			
		case .subFrames:
			subFrames = subFrames.clamped(to: validRange(of: .subFrames))
			
		}
		
	}
	
}

extension Timecode {
	
	/// Validates and clamps all timecode components to valid values at the current `frameRate` and `upperLimit` bound.
	public mutating func clampComponents() {
		
		__clamp(component: .days)
		__clamp(component: .hours)
		__clamp(component: .minutes)
		__clamp(component: .seconds)
		__clamp(component: .frames)
		__clamp(component: .subFrames)
		
	}
	
}

extension Timecode {
	
	/// Returns the largest subframe value displayable before rolling over to the next frame.
	@inlinable public var maxSubFramesExpressible: Int {
		
		validRange(of: .subFrames)
			.upperBound
		
	}
	
	/// Returns the `upperLimit` minus 1 subframe.
	@inlinable public var maxFramesAndSubframesExpressible: Double {
		
		Double(frameRate.maxTotalFramesExpressible(in: upperLimit))
			+ Double(maxSubFramesExpressible)
			/ Double(subFramesDivisor)
		
	}
	
}
