//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

// MARK: - .clamped(to:)

extension Comparable {
	
	// ie: 5.clamped(to: 7...10)
	// ie: 5.0.clamped(to: 7.0...10.0)
	// ie: "a".clamped(to: "b"..."h")
	/// CUSTOM SHARED:
	/// Returns the value clamped to the passed range.
	internal func clamped(to limits: ClosedRange<Self>) -> Self {
		return min(max(self, limits.lowerBound), limits.upperBound)
	}
	
	// ie: 5.clamped(to: 300...)
	// ie: 5.0.clamped(to: 300.00...)
	// ie: "a".clamped(to: "b"...)
	/// CUSTOM SHARED:
	/// Returns the value clamped to the passed range.
	internal func clamped(to limits: PartialRangeFrom<Self>) -> Self {
		return max(self, limits.lowerBound)
	}
	
	// ie: 400.clamped(to: ...300)
	// ie: 400.0.clamped(to: ...300.0)
	// ie: "k".clamped(to: ..."h")
	/// CUSTOM SHARED:
	/// Returns the value clamped to the passed range.
	internal func clamped(to limits: PartialRangeThrough<Self>) -> Self {
		return min(self, limits.upperBound)
	}
	
	// ie: 5.0.clamped(to: 7.0..<10.0)
	// not a good idea to implement this -- floating point numbers don't make sense in a ..< type range
	// because would the max of 7.0..<10.0 be 9.999999999...? It can't be 10.0.
	// func clamped(to limits: Range<Self>) -> Self { }
	
}

extension Strideable {
	
	// ie: 400.clamped(to: ..<300)
	// won't work for String
	/// CUSTOM SHARED:
	/// Returns the value clamped to the passed range.
	internal func clamped(to limits: PartialRangeUpTo<Self>) -> Self {
		return min(self, limits.upperBound.advanced(by: -1))	// advanced(by:) requires Strideable, not available on just Comparable
	}
	
}

extension Strideable where Self.Stride: SignedInteger {
	
	// ie: 5.clamped(to: 7..<10)
	// won't work for String
	/// CUSTOM SHARED:
	/// Returns the value clamped to the passed range.
	internal func clamped(to limits: Range<Self>) -> Self {
		return min(max(self, limits.lowerBound), limits.index(before: limits.upperBound))	// index(before:) only available on SignedInteger
	}
	
}
