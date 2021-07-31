//
//  Timecode FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation
@_implementationOnly import OTCore

extension Timecode {
    
    /// Returns the total number of whole frames elapsed from zero up to the timecode values.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    @inlinable public var frameCount: FrameCount {
        
        Self.frameCount(of: components,
                        at: frameRate,
                        subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Subframes are represented by the fractional portion of the number.
    /// Timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    @discardableResult
    @inlinable public mutating func setTimecode(exactly frameCount: FrameCount) -> Bool {
        
        guard frameCount >= .frames(0)
                && frameCount <= maxFrameCountExpressible
        else { return false }
        
        let converted = Self.components(from: frameCount,
                                        at: frameRate,
                                        subFramesDivisor: subFramesDivisor)
        
        days = converted.d
        hours = converted.h
        minutes = converted.m
        seconds = converted.s
        frames = converted.f
        subFrames = converted.sf
        
        return true
        
    }
    
}


// MARK: - Static methods

extension Timecode {
    
    /// Calculates total frames from given values at the current frame rate.
    public static func frameCount(of values: Components,
                                  at frameRate: FrameRate,
                                  subFramesDivisor: Int? = nil) -> FrameCount
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
            
            return .splitUnitInterval(frames: totalWholeFrames,
                                      subFramesUnitInterval: subFramesUnitInterval)
            
        case false:
            let dd = Double(values.d) * 24 * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let hh = Double(values.h) * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let mm = Double(values.m) * 60 * frameRate.frameRateForElapsedFramesCalculation
            let ss = Double(values.s) * frameRate.frameRateForElapsedFramesCalculation
            let totalWholeFrames = Int(round(dd + hh + mm + ss)) + values.f
            
            return .splitUnitInterval(frames: totalWholeFrames,
                                      subFramesUnitInterval: subFramesUnitInterval)
            
        }
        
    }
    
    /// Calculates resulting values from total frames at the current frame rate.
    /// (You can add subframes afterward to the `sf` property if needed.)
    @inline(__always)
    public static func components(from frameCount: FrameCount,
                                  at frameRate: FrameRate,
                                  subFramesDivisor: Int) -> Components
    {
        
        // prep vars
        
        var dd = 00
        var hh = 00
        var mm = 00
        var ss = 00
        var ff = 00
        var sf = 00
        
        var inElapsedFrames = frameCount.decimalValue(usingSubFramesDivisor: subFramesDivisor)
        
        // drop frame
        
        if frameRate.isDrop {
            
            // modify input elapsed frame count in the case of a drop-frame frame rate so it can be converted
            
            let framesPer10Minutes = Decimal(frameRate.frameRateForElapsedFramesCalculation) * Decimal(600.0)
            
            let D = (inElapsedFrames / framesPer10Minutes).truncated(decimalPlaces: 0)
            
            let M = inElapsedFrames.truncatingRemainder(dividingBy: framesPer10Minutes)
            
            let F = max(Decimal(0), M - Decimal(frameRate.framesDroppedPerMinute)) // don't allow negative numbers
            
            inElapsedFrames =
                inElapsedFrames
                + (9 * Decimal(frameRate.framesDroppedPerMinute) * D)
                + (
                    Decimal(frameRate.framesDroppedPerMinute)
                        * (F / ((framesPer10Minutes - Decimal(frameRate.framesDroppedPerMinute)) / 10))
                        .truncated(decimalPlaces: 0)
                )
            
        }
        
        // final calculation
        
        let frMaxFrames = Decimal(frameRate.maxFrames)
        
        dd = Int(truncating:
                    (inElapsedFrames / (frMaxFrames * 60 * 60 * 24))
                    .truncated(decimalPlaces: 0)
                    as NSDecimalNumber
        )
        
        hh = Int(truncating:
                    (inElapsedFrames / (frMaxFrames * 60 * 60))
                    .truncated(decimalPlaces: 0)
                    .truncatingRemainder(dividingBy: 24)
                    as NSDecimalNumber
        )
        
        mm = Int(truncating:
                    (inElapsedFrames / (frMaxFrames * 60))
                    .truncated(decimalPlaces: 0)
                    .truncatingRemainder(dividingBy: 60)
                    as NSDecimalNumber
        )
        
        ss = Int(truncating:
                    (inElapsedFrames / frMaxFrames)
                    .truncated(decimalPlaces: 0)
                    .truncatingRemainder(dividingBy: 60)
                    as NSDecimalNumber
        )
        
        ff = Int(truncating:
                    inElapsedFrames
                    .truncatingRemainder(dividingBy: frMaxFrames)
                    as NSDecimalNumber
        )
        
        sf = Int(truncating:
                    inElapsedFrames.fraction * Decimal(subFramesDivisor)
                    as NSDecimalNumber
        )
        
        return Components(d: dd, h: hh, m: mm, s: ss, f: ff, sf: sf)
        
    }
    
}
