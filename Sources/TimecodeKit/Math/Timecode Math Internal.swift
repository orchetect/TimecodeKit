//
//  Timecode Math Internal.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    
    // MARK: - Add
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __add(exactly duration: Components,
                        to base: Components) -> Components? {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.frameCount(of: duration,
                                    at: frameRate,
                                    subFramesDivisor: subFramesDivisor)
        
        let tcNew = tcOrigin.adding(tcAdd, usingSubFramesDivisor: subFramesDivisor)
        
        if tcNew < .frames(0) { return nil }
        if tcNew > maxFrameCountExpressible { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __add(clamping duration: Components,
                        to base: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.frameCount(of: duration,
                                    at: frameRate,
                                    subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
            + tcAdd.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
        
        tcNewSF = tcNewSF.clamped(to: 0...maxTotalSubframesExpressible)
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __add(wrapping duration: Components,
                        to base: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.frameCount(of: duration,
                                    at: frameRate,
                                    subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
            + tcAdd.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(in: upperLimit,
                                                            usingSubFramesDivisor: subFramesDivisor)
        
        let wrapRemainder = tcNewSF % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if tcNewSF < 0 {
            tcNewSF = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            tcNewSF = wrapRemainder
        }
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Subtract
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if overflows possible timecode values.
    @usableFromInline
    internal func __subtract(exactly duration: Components,
                             from base: Components) -> Components? {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.frameCount(of: duration,
                                         at: frameRate,
                                         subFramesDivisor: subFramesDivisor)
        
        let tcNew = tcOrigin.subtracting(tcSubtract, usingSubFramesDivisor: subFramesDivisor)
        
        if tcNew < .frames(0) { return nil }
        if tcNew > maxFrameCountExpressible { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    @usableFromInline
    internal func __subtract(clamping duration: Components,
                             from base: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.frameCount(of: duration,
                                         at: frameRate,
                                         subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
            - tcSubtract.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
        
        tcNewSF = tcNewSF.clamped(to: 0...maxTotalSubframesExpressible)
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __subtract(wrapping duration: Components,
                             from base: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: base,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.frameCount(of: duration,
                                         at: frameRate,
                                         subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
            - tcSubtract.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(in: upperLimit,
                                                            usingSubFramesDivisor: subFramesDivisor)
        
        let wrapRemainder = tcNewSF % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if tcNewSF < 0 {
            tcNewSF = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            tcNewSF = wrapRemainder
        }
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Multiply
    
    /// Utility function to multiply a base timecode by a duration.
    /// Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __multiply(exactly factor: Double,
                             with: Components) -> Components? {
        
        let tcOrigin = Self.frameCount(of: with,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        
        let tcNewSF = Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) * factor
        
        if tcNewSF < 0.0 { return nil }
        if tcNewSF > Double(maxTotalSubframesExpressible) { return nil }
        
        let tcNew = FrameCount(totalElapsedSubFrames: Int(tcNewSF),
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __multiply(clamping factor: Double,
                             with: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: with,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = Int(Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) * factor)
        
        tcNewSF = tcNewSF.clamped(to: 0...maxTotalSubframesExpressible)
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __multiply(wrapping factor: Double,
                             with: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: with,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = Int(Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) * factor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(in: upperLimit,
                                                            usingSubFramesDivisor: subFramesDivisor)
        
        let wrapRemainder = tcNewSF % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if tcNewSF < 0 {
            tcNewSF = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            tcNewSF = wrapRemainder
        }
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Divide
    
    /// Utility function to divide a base timecode by a duration.
    /// Returns `nil` if it overflows possible timecode values.
    @usableFromInline
    internal func __divide(exactly divisor: Double,
                           into: Components) -> Components? {
        
        let tcOrigin = Self.frameCount(of: into,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        
        let tcNewSF = Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) / divisor
        
        if tcNewSF < 0.0 { return nil }
        if tcNewSF > Double(maxTotalSubframesExpressible) { return nil }
        
        let tcNew = FrameCount(totalElapsedSubFrames: Int(tcNewSF),
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Clamps to valid timecodes between 0 and `upperLimit`.
    @usableFromInline
    internal func __divide(clamping divisor: Double,
                           into: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: into,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        var tcNewSF = Int(Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) / divisor)
        
        tcNewSF = tcNewSF.clamped(to: 0...maxTotalSubframesExpressible)
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __divide(wrapping divisor: Double,
                           into: Components) -> Components {
        
        let tcOrigin = Self.frameCount(of: into,
                                       at: frameRate,
                                       subFramesDivisor: subFramesDivisor)
        
        var tcNewSF = Int(Double(tcOrigin.totalSubFrames(usingSubFramesDivisor: subFramesDivisor)) / divisor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(in: upperLimit,
                                                            usingSubFramesDivisor: subFramesDivisor)
        
        let wrapRemainder = tcNewSF % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if tcNewSF < 0 {
            tcNewSF = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            tcNewSF = wrapRemainder
        }
        
        let tcNew = FrameCount(totalElapsedSubFrames: tcNewSF,
                               usingSubFramesDivisor: subFramesDivisor)
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Offset / Delta
    
    /// Utility function to return a Delta duration.
    @usableFromInline
    internal func __offset(to other: Components) -> Delta {
        
        if self.components == other {
            return Delta(TCC().toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor,
                                          displaySubFrames: displaySubFrames),
                         .positive)
        }
        
        let otherTimecode = Timecode(rawValues: other,
                                     at: frameRate,
                                     limit: ._100days,
                                     subFramesDivisor: subFramesDivisor,
                                     displaySubFrames: displaySubFrames)
        
        if otherTimecode > self {
            
            let diff = otherTimecode
                .__subtract(wrapping: components,
                            from: otherTimecode.components)
            
            let deltaTC = diff.toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor,
                                          displaySubFrames: displaySubFrames)
            
            let delta = Delta(deltaTC, .positive)
            
            return delta
            
        } else /* other < self */ {
            
            let diff = otherTimecode
                .__subtract(wrapping: other,
                            from: components)
            
            let deltaTC = diff.toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor,
                                          displaySubFrames: displaySubFrames)
            
            let delta = Delta(deltaTC, .negative)
            
            return delta
            
        }
        
    }
    
}
