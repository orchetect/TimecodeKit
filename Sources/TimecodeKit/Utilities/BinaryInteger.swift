//
//  File.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

extension BinaryInteger {
	
	/// CUSTOM SHARED:
	/// Returns number of digits (places to the left of the decimal) in the number.
	///
	/// ie:
	/// - for the integer 0, this would return 1
	/// - for the integer 5, this would return 1
	/// - for the integer 10, this would return 2
	/// - for the integer 250, this would return 3
	internal var numberOfDigits: Int {
		
		if self < 10 && self >= 0 || self > -10 && self < 0 {
			return 1
		} else {
			return 1 + (self / 10).numberOfDigits
		}
		
	}
	
}
