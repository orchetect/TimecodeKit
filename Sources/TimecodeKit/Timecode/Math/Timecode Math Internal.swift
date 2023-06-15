//
//  Timecode Math Internal.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Add
    
    /// Utility function to add a duration to a base timecode.
    /// Returns `nil` if it overflows possible timecode values.
    internal func _add(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to maximum timecode expressible.
    internal func _add(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func _add(
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
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Invalid values are retained without validation.
    internal func _add(
        rawValues duration: Components,
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
        
        let sfcNew = fcOrigin.subFrameCount + fcAdd.subFrameCount
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Subtract
    
    /// Utility function to add a duration to a base timecode.
    /// Returns `nil` if overflows possible timecode values.
    internal func _subtract(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Clamps to valid timecode as set by the `upperLimit` property.
    internal func _subtract(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func _subtract(
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
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to add a duration to a base timecode.
    /// Invalid values are retained without validation.
    internal func _subtract(
        rawValues duration: Components,
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
        
        let sfcNew = fcOrigin.subFrameCount - tcSubtract.subFrameCount
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Multiply
    
    /// Utility function to multiply a base timecode by a duration.
    /// Returns `nil` if it overflows possible timecode values.
    internal func _multiply(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Clamps to maximum timecode expressible.
    internal func _multiply(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func _multiply(
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
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to multiply a base timecode by a duration.
    /// Invalid values are retained without validation.
    internal func _multiply(
        rawValues factor: Double,
        with: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: with,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = Int(Double(fcOrigin.subFrameCount) * factor)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Divide
    
    /// Utility function to divide a base timecode by a duration.
    /// Returns `nil` if it overflows possible timecode values.
    internal func _divide(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Clamps to valid timecode between 0 and `upperLimit`.
    internal func _divide(
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
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    internal func _divide(
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
        
        // TODO: can implement later: also return number of times the value wrapped
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    /// Utility function to divide a base timecode by a duration.
    /// Invalid values are retained without validation.
    internal func _divide(
        rawValues divisor: Double,
        into: Components
    ) -> Components {
        let fcOrigin = Self.frameCount(
            of: into,
            at: frameRate,
            base: subFramesBase
        )
        
        let sfcNew = Int(Double(fcOrigin.subFrameCount) / divisor)
        
        let fcNew = FrameCount(
            subFrameCount: sfcNew,
            base: subFramesBase
        )
        
        return Self.components(
            of: fcNew,
            at: frameRate
        )
    }
    
    // MARK: - Offset / TimecodeInterval
    
    /// Utility function to return a `TimecodeInterval` interval.
    internal func _offset(to other: Components) -> TimecodeInterval {
        if components == other {
            return TimecodeInterval(
                Timecode.Components.zero.timecode(
                    at: frameRate,
                    base: subFramesBase,
                    limit: upperLimit,
                    by: .allowingInvalid
                ),
                .plus
            )
        }
        
        let otherTimecode = Timecode(
            .components(other),
            at: frameRate,
            base: subFramesBase,
            limit: ._100days,
            by: .allowingInvalid
        )
        
        if otherTimecode > self {
            let diff = otherTimecode._subtract(
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
            let diff = otherTimecode._subtract(
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
