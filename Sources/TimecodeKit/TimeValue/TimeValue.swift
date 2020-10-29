//
//  TimeValue.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

/// Primitive struct to represent real time.
///
/// In effort to retain precision, the value used when initializing will be stored unchanged, but can be accessed by either accessor. The backing value can be read as either `.seconds` or `.ms`. If the original format's property is get, the backing value will be returned unchanged. Otherwise it will be converted when needed when the properties are accessed.
public struct TimeValue {
	// MARK: Data backing

	private let msValue: Double?

	private let secondsValue: Double?

	// MARK: Public properties

	public let backing: UnitBacking

	public var ms: Double {
		if let msValue = msValue {
			return msValue

		} else if let secondsValue = secondsValue {
			return secondsValue * 1000.0

		} else {
			return 0.0
		}
	}

	public var seconds: Double {
		if let secondsValue = secondsValue {
			return secondsValue

		} else if let msValue = msValue {
			return msValue / 1000.0

		} else {
			return 0.0
		}
	}

	// MARK: init

	public init(ms: Double) {
		backing = .ms

		msValue = ms
		secondsValue = nil
	}

	public init(seconds: Double) {
		backing = .seconds

		msValue = nil
		secondsValue = seconds
	}
}

extension TimeValue: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		// limit precision to help ensure comparison is meaningful

		lhs.ms.truncated(decimalPlaces: 9) == rhs.ms.truncated(decimalPlaces: 9)
	}
}

extension TimeValue: Comparable {
	public static func <(lhs: Self, rhs: Self) -> Bool {
		// limit precision to help ensure comparison is meaningful

		lhs.ms.truncated(decimalPlaces: 9) < rhs.ms.truncated(decimalPlaces: 9)
	}
}

extension TimeValue {
	/// Enum describing units of time, as stored by `TimeValue`
	public enum UnitBacking {
		case ms
		case seconds
	}
}
