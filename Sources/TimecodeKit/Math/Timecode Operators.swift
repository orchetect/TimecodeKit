//
//  Timecode Operators.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

// MARK: - Math operators: Self, Self

extension Timecode {
	
	@inlinable static public func +(lhs: Self, rhs: Self) -> Timecode {
		
		lhs.adding(clamping: rhs.components)
		
	}
	
	@inlinable static public func +=(lhs: inout Self, rhs: Self) {
		
		lhs.add(clamping: rhs.components)
		
	}
	
	@inlinable static public func -(lhs: Self, rhs: Self) -> Timecode {
		
		lhs.subtracting(clamping: rhs.components)
		
	}
	
	@inlinable static public func -=(lhs: inout Self, rhs: Self) {
		
		lhs.subtract(clamping: rhs.components)
		
	}
	
}


// MARK: - Math operators: Self, BinaryInteger

extension Timecode {
	
	static public func *<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
		
		lhs.multiplying(clamping: Double(rhs))
		
	}
	
	static public func *=<T: BinaryInteger>(lhs: inout Self, rhs: T) {
		
		lhs.multiply(clamping: Double(rhs))
		
	}
	
	static public func /<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
		
		lhs.dividing(clamping: Double(rhs))
		
	}
	
	static public func /=<T: BinaryInteger>(lhs: inout Self, rhs: T) {
		
		lhs.divide(clamping: Double(rhs))
		
	}
	
}
