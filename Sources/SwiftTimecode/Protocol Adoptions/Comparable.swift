//
//  Comparable.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension OTTimecode: Equatable {
	
	static public func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.realTime == rhs.realTime
	}
	
}

extension OTTimecode: Comparable {
	
	static public func <(lhs: Self, rhs: Self) -> Bool {
		return (lhs.realTime < rhs.realTime)
	}
	
}
