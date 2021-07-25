//
//  Timecode Real Time.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode {
    
    /// (Lossy) Returns the current timecode converted to a duration in real-time (wall-clock time), based on the frame rate.
    ///
    /// Generally, `.realTimeValue` -> `.setTimecode(fromRealTimeValue:)` will produce equivalent timecodes.
    ///
    /// When setting, invalid values will cause the setter to fail silently.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public var realTimeValue: TimeInterval {
        
        get {
            Double(totalElapsedFrames) * (1.0 / frameRate.frameRateForRealTimeCalculation)
        }
        
        set {
            // set, suppressing failure silently
            _ = setTimecode(fromRealTimeValue: newValue)
        }
        
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate from real-time (wall-clock time).
    ///
    /// Returns false if it underflows or overflows valid timecode range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    @discardableResult
    public mutating func setTimecode(fromRealTimeValue: TimeInterval) -> Bool {
        
        // the basic calculation
        var calc = fromRealTimeValue / (1.0 / frameRate.frameRateForRealTimeCalculation)
        
        // over-estimate so real time is just past the equivalent timecode
        // since raw time values in practise can be a hair under the actual elapsed real time that would trigger the equivalent timecode (due to precision and rounding behaviors that may not be in our control, depending on where the passed real time value originated)
        
        calc += 0.000_010 // 10 microseconds
        
        // final calculation
        
        let elapsedFrames = calc
        let convertedComponents = Self.components(from: elapsedFrames,
                                                  at: frameRate,
                                                  subFramesDivisor: subFramesDivisor)
        
        return setTimecode(exactly: convertedComponents)
        
    }
    
}

// a.k.a: extension Double
extension TimeInterval {
    
    /// Convenience method to create an `Timecode` struct using the default `(_ exactly:)` initializer.
    @inlinable public func toTimecode(
        at frameRate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        subFramesDivisor: Int? = nil,
        displaySubFrames: Bool = false
    ) -> Timecode? {
        
        if let sfd = subFramesDivisor {
            
            return Timecode(realTimeValue: self,
                            at: frameRate,
                            limit: limit,
                            subFramesDivisor: sfd,
                            displaySubFrames: displaySubFrames)
            
        } else {
            
            return Timecode(realTimeValue: self,
                            at: frameRate,
                            limit: limit,
                            displaySubFrames: displaySubFrames)
            
        }
        
    }
    
}
