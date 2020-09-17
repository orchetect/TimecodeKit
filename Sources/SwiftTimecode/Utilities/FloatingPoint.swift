//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

// MARK: - ceiling / floor

extension FloatingPoint {
	
	/// CUSTOM SHARED: Convenience method to call `ceil()`
	internal var ceiling: Self {
		Darwin.ceil(self)
	}
	
	/// CUSTOM SHARED: Convenience method to call `floor()`
	internal var floor: Self {
		Darwin.floor(self)
	}
	
}

// MARK: - FloatingPointPower

/// CUSTOM SHARED:
/// Protocol allowing implementation of convenience methods for .power(_ exponent:)
internal protocol FloatingPointPower {
	func power(_ exponent: Self) -> Self
}


// MARK: - .power()

extension Double: FloatingPointPower {
	/// CUSTOM SHARED:
	/// Convenience method for pow()
	internal func power(_ exponent: Double) -> Double {
		pow(self, exponent)
	}
}

extension Float: FloatingPointPower {
	/// CUSTOM SHARED:
	/// Convenience method for pow()
	internal func power(_ exponent: Float) -> Float {
		powf(self, exponent)
	}
}

// Float80 seems to be deprecated as of the introduction of ARM64

//extension Float80: FloatingPointPower {
//	/// CUSTOM SHARED:
//	/// Convenience method for pow()
//	public func power(_ exponent: Float80) -> Float80 {
//		powl(self, exponent)
//	}
//}

extension Decimal {
	/// CUSTOM SHARED:
	/// Convenience method for pow()
	internal func power(_ exponent: Int) -> Decimal {
		pow(self, exponent)
	}
}


// MARK: - .truncated() / .rounded

extension FloatingPoint where Self : FloatingPointPower {
	
	/// CUSTOM SHARED:
	/// Truncates decimal places to `decimalPlaces` number of decimal places. If `decimalPlaces` <= 0, trunc(self) is returned.
	internal func truncated(decimalPlaces: Int) -> Self {
		if decimalPlaces < 1 {
			return trunc(self)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		return trunc(self * offset) / offset
	}
	
	/// CUSTOM SHARED:
	/// Replaces this value by truncating it to `decimalPlaces` number of decimal places. If `decimalPlaces` <= 0, trunc(self) is used.
	internal mutating func formTruncated(decimalPlaces: Int) {
		self = self.truncated(decimalPlaces: decimalPlaces)
	}
	
	/// CUSTOM SHARED:
	/// Rounds to `decimalPlaces` number of decimal places using rounding `rule`. If `decimalPlaces` <= 0, trunc(self) is returned.
	internal func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalPlaces: Int) -> Self {
		if decimalPlaces < 1 {
			return self.rounded(rule)
		}
		
		let offset = Self(10).power(Self(decimalPlaces))
		
		return (self * offset).rounded(rule) / offset
	}
	
	/// CUSTOM SHARED:
	/// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`. If `decimalPlaces` <= 0, trunc(self) is used.
	internal mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero, decimalPlaces: Int) {
		self = self.rounded(rule, decimalPlaces: decimalPlaces)
	}
	
}

extension FloatingPoint {
	
	/// CUSTOM SHARED:
	/// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
	///
	/// Note: Internally, employs `trunc()` and `.truncatingRemainder(dividingBy:)`.
	internal func quotientAndRemainder(dividingBy: Self) -> (quotient: Self, remainder: Self) {
		let calculation = (self / dividingBy)
		let integral = trunc(calculation)
		let fraction = self.truncatingRemainder(dividingBy: dividingBy)
		return (quotient: integral, remainder: fraction)
	}
	
	/// CUSTOM SHARED:
	/// Returns both integral part and fractional part.
	/// This methos is more computationally efficient than calling `.integral` and .`fraction` properties separately unless you only require one or the other.
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	internal var integralAndFraction: (integral: Self, fraction: Self) {
		let integral = trunc(self)
		let fraction = self - integral
		return (integral: integral, fraction: fraction)
	}
	
	/// CUSTOM SHARED:
	/// Returns the integral part (digits before the decimal point)
	internal var integral: Self {
		integralAndFraction.integral
	}
	
	/// CUSTOM SHARED:
	/// Returns the fractional part (digits after the decimal point)
	///
	/// Note: this can result in a non-trivial loss of precision for the fractional part.
	internal var fraction: Self {
		integralAndFraction.fraction
	}
	
}
