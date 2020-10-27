//
//  Comparable.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode: Equatable {
	
	static public func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.realTime == rhs.realTime
	}
	
}

extension Timecode: Comparable {
	
	static public func <(lhs: Self, rhs: Self) -> Bool {
		lhs.realTime < rhs.realTime
	}
	
}
