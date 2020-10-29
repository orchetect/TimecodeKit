//
//  Comparable.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.realTime == rhs.realTime
	}
}

extension Timecode: Comparable {
	public static func <(lhs: Self, rhs: Self) -> Bool {
		lhs.realTime < rhs.realTime
	}
}
