//
//  OTTimecode Operators.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - Math operators: Self, Self

extension OTTimecode {
	
	static public func +(lhs: Self, rhs: Self) -> OTTimecode {
		return lhs.adding(clamping: rhs.components)
	}
	
	static public func +=(lhs: inout Self, rhs: Self) {
		lhs.add(clamping: rhs.components)
	}
	
	static public func -(lhs: Self, rhs: Self) -> OTTimecode {
		return lhs.subtracting(clamping: rhs.components)
	}
	
	static public func -=(lhs: inout Self, rhs: Self) {
		lhs.subtract(clamping: rhs.components)
	}
	
}


// MARK: - Math operators: Self, BinaryInteger

extension OTTimecode {
	
	static public func *<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
		return lhs.multiplying(clamping: Double(rhs))
	}
	
	static public func *=<T: BinaryInteger>(lhs: inout Self, rhs: T) {
		lhs.multiply(clamping: Double(rhs))
	}
	
	static public func /<T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
		return lhs.dividing(clamping: Double(rhs))
	}
	
	static public func /=<T: BinaryInteger>(lhs: inout Self, rhs: T) {
		lhs.divide(clamping: Double(rhs))
	}
	
}
