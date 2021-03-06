//
//  CustomStringConvertible.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-08-17.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

extension Timecode: CustomStringConvertible, CustomDebugStringConvertible {
	
	@inlinable public var description: String {
		
		stringValue
		
	}
	
	public var debugDescription: String {
		
		// include Days even if it's 0 if we have a mode set that enables Days
		let daysString =
			upperLimit == UpperLimit._100days
			? "\(days):"
			: ""
		
		return "Timecode<\(daysString)\(stringValue) @ \(frameRate.stringValue)>"
		
	}
	
	public var verboseDescription: String {
		
		"\(stringValue) @ \(frameRate.stringValue)"
		
	}
	
}
