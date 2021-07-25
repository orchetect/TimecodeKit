//
//  FrameRate String Extensions.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-08-18.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

extension String {
    
    /// Convenience method to call `Timecode.FrameRate(stringValue: self)`
    public var toFrameRate: Timecode.FrameRate? {
        
        Timecode.FrameRate(stringValue: self)
        
    }
    
}
