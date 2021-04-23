//
//  Timecode Math Public.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

extension Timecode {
	
	// MARK: - Add
	
	/// Add a duration to the current timecode.
	/// Returns false if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func add(_ exactly: Components) -> Bool {
		
		guard let newTC = __add(exactly: exactly,
								to: components) else { return false }
		
		return setTimecode(exactly: newTC)
		
	}
	
	/// Add a duration to the current timecode.
	/// Clamps to valid timecodes.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func add(clamping values: Components) {
		
		let newTC = __add(clamping: values,
						  to: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Add a duration to the current timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func add(wrapping values: Components) {
		
		let newTC = __add(wrapping: values,
						  to: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Add a duration to the current timecode and return a new instance with the new timecode.
	/// Returns nil if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func adding(_ exactly: Components) -> Timecode? {
		
		guard let newTC = __add(exactly: exactly,
								to: components) else { return nil }
		
		var newTimecode = self // copy self
		guard newTimecode.setTimecode(exactly: newTC) else { return nil }
		
		return newTimecode
		
	}
	
	/// Add a duration to the current timecode and return a new instance with the new timecode.
	/// Clamps to valid timecodes as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func adding(clamping values: Components) -> Timecode {
		
		let newTC = __add(clamping: values,
						  to: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	/// Add a duration to the current timecode and return a new instance with the new timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func adding(wrapping values: Components) -> Timecode {
		
		let newTC = __add(wrapping: values,
						  to: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	
	// MARK: - Subtract
	
	/// Subtract a duration from the current timecode.
	/// Returns false if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func subtract(_ exactly: Components) -> Bool {
		
		guard let newTC = __subtract(exactly: exactly,
									 from: components) else { return false }
		
		return setTimecode(exactly: newTC)
		
	}
	
	/// Subtract a duration from the current timecode.
	/// Clamps to valid timecodes.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func subtract(clamping: Components) {
		
		let newTC = __subtract(clamping: clamping,
							   from: components)
		
		_ = setTimecode(exactly: newTC)
		
	}
	
	/// Subtract a duration from the current timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public mutating func subtract(wrapping: Components) {
		
		let newTC = __subtract(wrapping: wrapping,
							   from: components)
		
		_ = setTimecode(exactly: newTC)
		
	}
	
	/// Subtract a duration from the current timecode and return a new instance with the new timecode.
	/// Returns nil if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func subtracting(_ exactly: Components) -> Timecode? {
		
		guard let newTC = __subtract(exactly: exactly,
									 from: components) else { return nil }
		
		var newTimecode = self // copy self
		guard newTimecode.setTimecode(exactly: newTC) else { return nil }
		
		return newTimecode
		
	}
	
	/// Subtract a duration from the current timecode and return a new instance with the new timecode.
	/// Clamps to valid timecodes.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func subtracting(clamping values: Components) -> Timecode {
		
		let newTC = __subtract(clamping: values,
							   from: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	/// Subtract a duration from the current timecode and return a new instance with the new timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	@inlinable public func subtracting(wrapping values: Components) -> Timecode {
		
		let newTC = __subtract(wrapping: values,
							   from: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	
	// MARK: - Multiply
	
	/// Multiply the current timecode by an amount.
	/// Returns false if resulting value is > the `upperLimit` property.
	public mutating func multiply(_ exactly: Double) -> Bool {
		
		guard let newTC = __multiply(exactly: exactly,
									 with: components) else { return false }
		
		return setTimecode(exactly: newTC)
		
	}
	
	/// Multiply the current timecode by an amount.
	/// Clamps the result to the `upperLimit` property.
	public mutating func multiply(clamping value: Double) {
		
		let newTC = __multiply(clamping: value, with: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Multiply the current timecode by an amount.
	/// Wraps around the clock as set by the `upperLimit` property.
	public mutating func multiply(wrapping value: Double) {
		
		let newTC = __multiply(wrapping: value, with: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Multiply a duration from the current timecode and return a new instance with the new timecode.
	/// Returns nil if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func multiplying(_ exactly: Double) -> Timecode? {
		
		guard let newTC = __multiply(exactly: exactly, with: components) else { return nil }
		
		var newTimecode = self // copy self
		guard newTimecode.setTimecode(exactly: newTC) else { return nil }
		
		return newTimecode
		
	}
	
	/// Multiply a duration from the current timecode and return a new instance with the new timecode.
	/// Clamps to valid timecodes.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func multiplying(clamping value: Double) -> Timecode {
		
		let newTC = __multiply(clamping: value, with: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	/// Multiply a duration from the current timecode and return a new instance with the new timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func multiplying(wrapping value: Double) -> Timecode {
		
		let newTC = __multiply(wrapping: value, with: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	
	// MARK: - Divide
	
	/// Divide the current timecode by a duration.
	/// Returns false if resulting value is > the `upperLimit` property.
	public mutating func divide(_ exactly: Double) -> Bool {
		
		guard let newTC = __divide(exactly: exactly, into: components) else { return false }
		
		return setTimecode(exactly: newTC)
		
	}
	
	/// Divide the current timecode by a duration.
	/// Clamps to valid timecodes.
	public mutating func divide(clamping value: Double) {
		
		let newTC = __divide(clamping: value, into: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Divide the current timecode by a duration.
	/// Wraps around the clock as set by the `upperLimit` property.
	public mutating func divide(wrapping value: Double) {
		
		let newTC = __divide(wrapping: value, into: components)
		
		_ = setTimecode(exactly: newTC) // guaranteed to work
		
	}
	
	/// Divide the current timecode by a duration and return a new instance with the new timecode.
	/// Returns nil if resulting value is not within valid timecode range.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func dividing(_ exactly: Double) -> Timecode? {
		
		guard let newTC = __divide(exactly: exactly, into: components) else { return nil }
		
		var newTimecode = self // copy self
		guard newTimecode.setTimecode(exactly: newTC) else { return nil }
		
		return newTimecode
		
	}
	
	/// Divide the current timecode by a duration and return a new instance with the new timecode.
	/// Clamps to valid timecodes.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func dividing(clamping value: Double) -> Timecode {
		
		let newTC = __divide(clamping: value, into: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	/// Divide the current timecode by a duration and return a new instance with the new timecode.
	/// Wraps around the clock as set by the `upperLimit` property.
	/// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
	public func dividing(wrapping value: Double) -> Timecode {
		
		let newTC = __divide(wrapping: value, into: components)
		
		var newTimecode = self // copy self
		_ = newTimecode.setTimecode(exactly: newTC) // guaranteed to work
		
		return newTimecode
		
	}
	
	
	// MARK: - Offset / Delta
	
	/// Offsets the current timecode by a `Delta` amount.
	/// Wraps around the clock as set by the `upperLimit` property.
	public mutating func offset(by delta: Delta) {
		
		self = delta.timecode(offsetting: self)
		
	}
	
	/// Returns the timecode offset by a `Delta` amount.
	/// Wraps around the clock as set by the `upperLimit` property.
	public func offsetting(by delta: Delta) -> Timecode {
		
		delta.timecode(offsetting: self)
		
	}
	
	/// Returns an abstract delta distance between the current timecode and another timecode.
	public func delta(to other: Timecode) -> Delta {
		
		__offset(to: other.components)
		
	}
	
}
