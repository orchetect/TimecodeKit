//
//  Timecode Math Internal.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Add
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if it overflows possible timecode values.
    internal func __add(
        exactly duration: Components,
        to base: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        let sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        if sfcNew < 0 { return nil }
        if sfcNew > maxFrameCountExpressible.subFrameCount { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to maximum timecode expressible.
    internal func __add(
        clamping duration: Components,
        to base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func __add(
        wrapping duration: Components,
        to base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let fcAdd = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        let maxTotalSubFrames = properties.frameRate.maxTotalSubFrames(
            in: properties.upperLimit,
            base: properties.subFramesBase
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
            base: properties.subFramesBase
        )
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    // MARK: - Subtract
    
    /// Utility function to add a duration to a base timecode.
    /// Returns nil if overflows possible timecode values.
    internal func __subtract(
        exactly duration: Components,
        from base: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        let sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        if sfcNew < 0 { return nil }
        if sfcNew > maxFrameCountExpressible.subFrameCount { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to valid timecode as set by the `upperLimit` property.
    internal func __subtract(
        clamping duration: Components,
        from base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func __subtract(
        wrapping duration: Components,
        from base: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: base,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        let tcSubtract = Self.frameCount(
            of: duration,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        let maxTotalSubFrames = properties.frameRate.maxTotalSubFrames(
            in: properties.upperLimit,
            base: properties.subFramesBase
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
            base: properties.subFramesBase
        )
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    // MARK: - Multiply
    
    /// Utility function to multiply a base timecode by a duration.
    /// Returns nil if it overflows possible timecode values.
    internal func __multiply(
        exactly factor: Double,
        with: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: with,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        let sfcNew = Double(fcOrigin.subFrameCount) * factor
        
        if sfcNew < 0.0 { return nil }
        if sfcNew > Double(maxSubFrameCountExpressible) { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: Int(sfcNew),
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Clamps to maximum timecode expressible.
    internal func __multiply(
        clamping factor: Double,
        with: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: with,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) * factor)
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func __multiply(
        wrapping factor: Double,
        with: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: with,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) * factor)
        
        let maxTotalSubFrames = properties.frameRate.maxTotalSubFrames(
            in: properties.upperLimit,
            base: properties.subFramesBase
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
            base: properties.subFramesBase
        )
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    // MARK: - Divide
    
    /// Utility function to divide a base timecode by a duration.
    /// Returns `nil` if it overflows possible timecode values.
    internal func __divide(
        exactly divisor: Double,
        into: Components
    ) -> Components? {
        let fcOrigin = Self.frameCount(
            of: into,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        let sfcNew = Double(fcOrigin.subFrameCount) / divisor
        
        if sfcNew < 0.0 { return nil }
        if sfcNew > Double(maxSubFrameCountExpressible) { return nil }
        
        let fcNew = FrameCount(
            subFrameCount: Int(sfcNew),
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Clamps to valid timecode between 0 and `upperLimit`.
    internal func __divide(
        clamping divisor: Double,
        into: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: into,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        var sfcNew = Int(Double(fcOrigin.subFrameCount) / divisor)
        
        sfcNew = sfcNew.clamped(to: 0 ... maxSubFrameCountExpressible)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: properties.subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func __divide(
        wrapping divisor: Double,
        into: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: into,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
        
        var sfcNew = Int(Double(fcOrigin.subFrameCount) / divisor)
        
        let maxTotalSubFrames = properties.frameRate.maxTotalSubFrames(
            in: properties.upperLimit,
            base: properties.subFramesBase
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
            base: properties.subFramesBase
        )
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: properties.frameRate
        )
    }
    
    // MARK: - Offset / TimecodeInterval
    
    /// Utility function to return a `TimecodeInterval` interval.
    internal func __offset(to other: Components) -> TimecodeInterval {
        if components == other {
            return TimecodeInterval(
                Timecode.Components.zero
                    .timecode(
                        using: .init(
                            rate: properties.frameRate,
                            base: properties.subFramesBase,
                            limit: properties.upperLimit
                        ),
                        by: .allowingInvalid
                    ),
                .plus
            )
        }
        
        let otherTimecode = Timecode(
            .components(other),
            using: .init(
                rate: properties.frameRate,
                base: properties.subFramesBase,
                limit: ._100days
            ),
            by: .allowingInvalid
        )
        
        if otherTimecode > self {
            let diff = otherTimecode.__subtract(
                wrapping: components,
                from: otherTimecode.components
            )
            
            let deltaTC = diff.timecode(
                using: properties,
                by: .allowingInvalid
            )
            
            let delta = TimecodeInterval(deltaTC, .plus)
            
            return delta
            
        } else /* other < self */ {
            let diff = otherTimecode.__subtract(
                wrapping: other,
                from: components
            )
            
            let deltaTC = diff.timecode(
                using: properties,
                by: .allowingInvalid
            )
            
            let delta = TimecodeInterval(deltaTC, .minus)
            
            return delta
        }
    }
}
