//
//  Timecode Math Internal.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    
    // MARK: - Add
    
    /// Utility function to add a duration to a base timecode. Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __add(exactly duration: Components,
                        to base: Components) -> Components? {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.totalElapsedFrames(of: duration,
                                            at: frameRate,
                                            subFramesDivisor: subFramesDivisor)
        let tcNew = tcOrigin + tcAdd
        
        if tcNew > maxFramesAndSubframesExpressible { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode. Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __add(clamping duration: Components,
                        to base: Components) -> Components {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.totalElapsedFrames(of: duration,
                                            at: frameRate,
                                            subFramesDivisor: subFramesDivisor)
        var tcNew = tcOrigin + tcAdd
        
        tcNew = tcNew.clamped(to: 0.0...maxFramesAndSubframesExpressible)
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode. Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __add(wrapping duration: Components,
                        to base: Components) -> Components {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcAdd = Self.totalElapsedFrames(of: duration,
                                            at: frameRate,
                                            subFramesDivisor: subFramesDivisor)
        var tcNew = tcOrigin + tcAdd
        
        let wrapTest = tcNew.quotientAndRemainder(dividingBy: Double(frameRate.maxTotalFrames(in: upperLimit)))
        
        // check for a negative result and wrap accordingly
        if tcNew < 0.0 {
            tcNew = Double(frameRate.maxTotalFrames(in: upperLimit)) + wrapTest.remainder // wrap around
        } else {
            tcNew = wrapTest.remainder
        }
        
        // TODO: - ***** can implement later: number of times the value wrapped will be stored in wrapTest.quotient
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Subtract
    
    /// Utility function to add a duration to a base timecode. Returns nil if overflows possible timecode values.
    @usableFromInline
    internal func __subtract(exactly duration: Components,
                             from base: Components) -> Components? {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.totalElapsedFrames(of: duration,
                                                 at: frameRate,
                                                 subFramesDivisor: subFramesDivisor)
        let tcNew = tcOrigin - tcSubtract
        
        if tcNew < 0 { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode. Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __subtract(clamping duration: Components,
                             from base: Components) -> Components {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.totalElapsedFrames(of: duration,
                                                 at: frameRate,
                                                 subFramesDivisor: subFramesDivisor)
        let tcNew = tcOrigin - tcSubtract
        
        if tcNew < 0 { return Components(d: 0, h: 0, m: 0, s: 0, f: 0) }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to add a duration to a base timecode. Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __subtract(wrapping duration: Components,
                             from base: Components) -> Components {
        
        let tcOrigin = Self.totalElapsedFrames(of: base,
                                               at: frameRate,
                                               subFramesDivisor: subFramesDivisor)
        let tcSubtract = Self.totalElapsedFrames(of: duration,
                                                 at: frameRate,
                                                 subFramesDivisor: subFramesDivisor)
        var tcNew = tcOrigin - tcSubtract
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        let wrapTest = tcNew.quotientAndRemainder(dividingBy: Double(frameRate.maxTotalFrames(in: upperLimit)))
        
        if tcNew < 0 {
            tcNew = Double(frameRate.maxTotalFrames(in: upperLimit)) + wrapTest.remainder // wrap around
            return Self.components(from: tcNew,
                                   at: frameRate,
                                   subFramesDivisor: subFramesDivisor)
        } else {
            return Self.components(from: wrapTest.remainder,
                                   at: frameRate,
                                   subFramesDivisor: subFramesDivisor)
        }
        
    }
    
    
    // MARK: - Multiply
    
    /// Utility function to multiply a base timecode by a duration. Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __multiply(exactly duration: Double,
                             with: Components) -> Components? {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: with,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        let tcNew = Int(tcOrigin * duration)
        
        if tcNew > frameRate.maxTotalFramesExpressible(in: upperLimit) { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to multiply a base timecode by a duration. Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __multiply(clamping duration: Double,
                             with: Components) -> Components {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: with,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        var tcNew = Int(tcOrigin * duration)
        
        tcNew = tcNew.clamped(to: 0...frameRate.maxTotalFramesExpressible(in: upperLimit))
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to multiply a base timecode by a duration. Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __multiply(wrapping duration: Double,
                             with: Components) -> Components {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: with,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        var tcNew = Int(tcOrigin * duration)
        
        let wrapTest = tcNew.quotientAndRemainder(dividingBy: frameRate.maxTotalFrames(in: upperLimit))
        
        // check for a negative result and wrap accordingly
        if tcNew < 0 {
            tcNew = frameRate.maxTotalFrames(in: upperLimit) + wrapTest.remainder // wrap around
        } else {
            tcNew = wrapTest.remainder
        }
        
        // TODO: - ***** can implement later: number of times the value wrapped will be stored in wrapTest.quotient
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Divide
    
    /// Utility function to divide a base timecode by a duration. Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __divide(exactly duration: Double,
                           into: Components) -> Components? {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: into,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        let tcNew = Int(tcOrigin / duration)
        
        if tcNew > frameRate.maxTotalFramesExpressible(in: upperLimit) { return nil }
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to divide a base timecode by a duration. Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __divide(clamping duration: Double,
                           into: Components) -> Components {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: into,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        var tcNew = Int(tcOrigin / duration)
        
        tcNew = tcNew.clamped(to: 0...frameRate.maxTotalFramesExpressible(in: upperLimit))
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    /// Utility function to divide a base timecode by a duration. Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __divide(wrapping duration: Double,
                           into: Components) -> Components {
        
        let tcOrigin = Double(Self.totalElapsedFrames(of: into,
                                                      at: frameRate,
                                                      subFramesDivisor: subFramesDivisor))
        var tcNew = Int(tcOrigin / duration)
        
        let wrapTest = tcNew.quotientAndRemainder(dividingBy: frameRate.maxTotalFrames(in: upperLimit))
        
        // check for a negative result and wrap accordingly
        if tcNew < 0 {
            tcNew = frameRate.maxTotalFrames(in: upperLimit) + wrapTest.remainder // wrap around
        } else {
            tcNew = wrapTest.remainder
        }
        
        // TODO: - ***** can implement later: number of times the value wrapped will be stored in wrapTest.quotient
        
        return Self.components(from: tcNew,
                               at: frameRate,
                               subFramesDivisor: subFramesDivisor)
        
    }
    
    
    // MARK: - Offset / Delta
    
    /// Utility function to return a Delta duration.
    @usableFromInline
    internal func __offset(to other: Components) -> Delta {
        
        if self.components == other {
            return .init(TCC().toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor),
                         .positive)
        }
        
        let otherTimecode = Timecode(rawValues: other,
                                     at: frameRate,
                                     limit: ._100days,
                                     subFramesDivisor: subFramesDivisor)
        
        if otherTimecode > self {
            
            let diff = otherTimecode
                .__subtract(wrapping: components,
                            from: otherTimecode.components)
            
            let deltaTC = diff.toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor)
            
            let delta = Delta(deltaTC, .positive)
            
            return delta
            
        } else /* other < self */ {
            
            let diff = otherTimecode
                .__subtract(wrapping: other,
                            from: components)
            
            let deltaTC = diff.toTimecode(rawValuesAt: frameRate,
                                          limit: upperLimit,
                                          subFramesDivisor: subFramesDivisor)
            
            let delta = Delta(deltaTC, .negative)
            
            return delta
            
        }
        
    }
    
}
