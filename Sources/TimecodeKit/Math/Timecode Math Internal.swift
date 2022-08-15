//
//  Timecode Math Internal.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Add
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __add(
        exactly duration: Components,
        to base: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        if sfcNew < 0 { return nil }
        if sfcNew > maxFrameCountExpressible.subFrameCount { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __add(
        clamping duration: Components,
        to base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __add(
        wrapping duration: Components,
        to base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(
            in: upperLimit,
            base: subFramesBase
        )
        
        let wrapRemainder = sfcNew % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if sfcNew < 0 {
            sfcNew = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            sfcNew = wrapRemainder
        }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Subtract
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if overflows possible timecode values.
    @usableFromInline
    internal func __subtract(
        exactly duration: Components,
        from base: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        if sfcNew < 0 { return nil }
        if sfcNew > maxFrameCountExpressible.subFrameCount { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    @usableFromInline
    internal func __subtract(
        clamping duration: Components,
        from base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __subtract(
        wrapping duration: Components,
        from base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: frameRate,
            base: subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(
            in: upperLimit,
            base: subFramesBase
        )
        
        let wrapRemainder = sfcNew % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if sfcNew < 0 {
            sfcNew = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            sfcNew = wrapRemainder
        }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Multiply
    
    /// Utility function to multiply a base timecode by a duration.
    /// Returns nil if it overflows possible timecode values.
    @usableFromInline
    internal func __multiply(
        exactly factor: Double,
        with: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: with,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = Double(fcOrigin.subFrameCount) * factor
        
        if sfcNew < 0.0 { return nil }
        if sfcNew > Double(maxSubFrameCountExpressible) { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: Int(sfcNew),
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Clamps to maximum timecode expressible.
    @usableFromInline
    internal func __multiply(
        clamping factor: Double,
        with: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: with,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) * factor)
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __multiply(
        wrapping factor: Double,
        with: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: with,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) * factor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(
            in: upperLimit,
            base: subFramesBase
        )
        
        let wrapRemainder = sfcNew % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if sfcNew < 0 {
            sfcNew = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            sfcNew = wrapRemainder
        }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Divide
    
    /// Utility function to divide a base timecode by a duration.
    /// Returns `nil` if it overflows possible timecode values.
    @usableFromInline
    internal func __divide(
        exactly divisor: Double,
        into: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: into,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = Double(fcOrigin.subFrameCount) / divisor
        
        if sfcNew < 0.0 { return nil }
        if sfcNew > Double(maxSubFrameCountExpressible) { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: Int(sfcNew),
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Clamps to valid timecodes between 0 and `upperLimit`.
    @usableFromInline
    internal func __divide(
        clamping divisor: Double,
        into: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: into,
            at: frameRate,
            base: subFramesBase
        )
        var sfcNew = Int(Double(fcOrigin.subFrameCount) / divisor)
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    @usableFromInline
    internal func __divide(
        wrapping divisor: Double,
        into: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: into,
            at: frameRate,
            base: subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) / divisor)
        
        let maxTotalSubFrames = frameRate.maxTotalSubFrames(
            in: upperLimit,
            base: subFramesBase
        )
        
        let wrapRemainder = sfcNew % maxTotalSubFrames
        
        // check for a negative result and wrap accordingly
        if sfcNew < 0 {
            sfcNew = maxTotalSubFrames + wrapRemainder // wrap around
        } else {
            sfcNew = wrapRemainder
        }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        // TODO: - ***** can implement later: also return number of times the value wrapped
        
        return Self.components(
            from: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Offset / Delta
    
    /// Utility function to return a Delta duration.
    @usableFromInline
    internal func __offset(to other: Components) -> Delta {
        if components == other {
            return Delta(
                TCC().toTimecode(
                    rawValuesAt: frameRate,
                    limit: upperLimit,
                    base: subFramesBase,
                    format: stringFormat
                ),
                .positive
            )
        }
        
        let otherTimecode = Timecode(
            rawValues: other,
            at: frameRate,
            limit: ._100days,
            base: subFramesBase,
            format: stringFormat
        )
        
        if otherTimecode > self {
            let diff = otherTimecode
                .__subtract(
                    wrapping: components,
                    from: otherTimecode.components
                )
            
            let deltaTC = diff.toTimecode(
                rawValuesAt: frameRate,
                limit: upperLimit,
                base: subFramesBase,
                format: stringFormat
            )
            
            let delta = Delta(deltaTC, .positive)
            
            return delta
            
        } else /* other < self */ {
            let diff = otherTimecode
                .__subtract(
                    wrapping: other,
                    from: components
                )
            
            let deltaTC = diff.toTimecode(
                rawValuesAt: frameRate,
                limit: upperLimit,
                base: subFramesBase,
                format: stringFormat
            )
            
            let delta = Delta(deltaTC, .negative)
            
            return delta
        }
    }
}
