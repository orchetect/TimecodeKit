//
//  Timecode Elapsed Frames.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Darwin

extension Timecode {
    
    /// Returns the total number of whole frames elapsed from zero up to the timecode values.
    /// When set, timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    @inlinable public var totalElapsedFrames: Double {
        
        get {
            Self.totalElapsedFrames(of: components,
                                    at: frameRate,
                                    subFramesDivisor: subFramesDivisor)
        }
        set {
            guard newValue >= 0.0
                    && newValue <= maxFramesAndSubframesExpressible
            else { return }
            
            let converted = Self.components(from: newValue,
                                            at: frameRate,
                                            subFramesDivisor: subFramesDivisor)
            
            days = converted.d
            hours = converted.h
            minutes = converted.m
            seconds = converted.s
            frames = converted.f
            subFrames = converted.sf
        }
        
    }
    
}


// MARK: - Static methods

extension Timecode {
    
    /// Internal func: calculates total frames from given values at the current frame rate.
    /// Subframes are represented by the fractional portion of the number.
    public static func totalElapsedFrames(of values: Components,
                                          at frameRate: FrameRate,
                                          subFramesDivisor: Int? = nil) -> Double
    {
        
        let subFramesUnitInterval =
            subFramesDivisor == nil
            ? 0.0
            : Double(values.sf) / Double(subFramesDivisor!)
        
        switch frameRate.isDrop {
        case true:
            let totalMinutes = (24 * 60 * values.d) + (60 * values.h) + values.m
            
            let totalWholeFrames =
                (
                    (frameRate.maxFrames * 60 * 60 * 24 * values.d)
                        + (frameRate.maxFrames * 60 * 60 * values.h)
                        + (frameRate.maxFrames * 60 * values.m)
                        + (frameRate.maxFrames * values.s)
                        + (values.f)
                )
                
                - (Int(frameRate.framesDroppedPerMinute) * (totalMinutes - (totalMinutes / 10)))
            
            let totalFramesPlusSubframes = Double(totalWholeFrames) + subFramesUnitInterval
            
            return totalFramesPlusSubframes
            
        case false:
            let dd = Double(values.d) * 24 * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let hh = Double(values.h) * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let mm = Double(values.m) * 60 * frameRate.frameRateForElapsedFramesCalculation
            let ss = Double(values.s) * frameRate.frameRateForElapsedFramesCalculation
            let totalWholeFrames = Int(round(dd + hh + mm + ss)) + values.f
            
            let totalFramesPlusSubframes = Double(totalWholeFrames) + subFramesUnitInterval
            
            return totalFramesPlusSubframes
            
        }
        
    }
    
    /// Internal func: calculates resulting values from total frames at the current frame rate.
    /// (You can add subframes afterward to the `sf` property if needed.)
    @inlinable public static func components(from totalElapsedFrames: Int,
                                             at frameRate: FrameRate,
                                             subFramesDivisor: Int?) -> Components
    {
        
        components(from: Double(totalElapsedFrames),
                   at: frameRate,
                   subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Internal func: calculates resulting values from total frames at the current frame rate.
    /// (You can add subframes afterward to the `sf` property if needed.)
    @inlinable public static func components(from totalElapsedFrames: Double,
                                             at frameRate: FrameRate,
                                             subFramesDivisor: Int?) -> Components
    {
        
        // prep vars
        
        var dd = 00
        var hh = 00
        var mm = 00
        var ss = 00
        var ff = 00
        var sf = 00
        
        var inElapsedFrames = Double(totalElapsedFrames)
        
        // drop frame
        
        if frameRate.isDrop {
            
            // modify input elapsed frame count in the case of a drop-frame frame rate so it can be converted
            
            let framesPer10Minutes = frameRate.frameRateForElapsedFramesCalculation * 600
            
            let D = floor(inElapsedFrames / framesPer10Minutes)
            
            let M = inElapsedFrames.truncatingRemainder(dividingBy: framesPer10Minutes)
            
            let F = max(0, M - frameRate.framesDroppedPerMinute) // don't allow negative numbers
            
            inElapsedFrames =
                inElapsedFrames
                + (9 * frameRate.framesDroppedPerMinute * D)
                + (frameRate.framesDroppedPerMinute
                    * floor(F / ((framesPer10Minutes - frameRate.framesDroppedPerMinute) / 10)) )
            
        }
        
        // final calculation
        
        let frMaxFrames = Double(frameRate.maxFrames)
        
        dd = Int(
            (inElapsedFrames / (frMaxFrames * 60 * 60 * 24))
                .floor
        )
        
        hh = Int(
            (inElapsedFrames / (frMaxFrames * 60 * 60))
                .floor
                .truncatingRemainder(dividingBy: 24)
        )
        
        mm = Int(
            (inElapsedFrames / (frMaxFrames * 60))
                .floor
                .truncatingRemainder(dividingBy: 60)
        )
        
        ss = Int(
            (inElapsedFrames / frMaxFrames)
                .floor
                .truncatingRemainder(dividingBy: 60)
        )
        
        ff = Int(
            inElapsedFrames
                .truncatingRemainder(dividingBy: frMaxFrames)
        )
        
        if let sfDiv = subFramesDivisor {
            sf = Int(inElapsedFrames.fraction * Double(sfDiv))
        }
        
        return Components(d: dd, h: hh, m: mm, s: ss, f: ff, sf: sf)
        
    }
    
}
