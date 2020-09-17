//
//  FrameRate String Extensions.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-08-18.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension String {
	
	/// Convenience method to call `OTTimecode.FrameRate(stringValue: self)`
	public var toFrameRate: OTTimecode.FrameRate? {
		
		OTTimecode.FrameRate(stringValue: self)
		
	}
	
}
