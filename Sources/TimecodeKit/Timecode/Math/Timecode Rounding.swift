//
//  Timecode Rounding.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Rounding
    
    // note: this comment block is identical to roundUp() but has the method name changed
    
    /// Returns the timecode rounded up to the next whole component value.
    /// If all subsequently smaller component values are already 0 then no
    /// change is made of course.
    /// Passing ``Component/subFrames`` has no effect, as it is the smallest component.
    ///
    /// ie:
    ///
    /// ```
    /// try Timecode(.string("01:02:03:04.00"), at: ._24)
    ///     .roundedUp(toNearest: .frames)
    /// // == "01:02:03:04.00" // no change
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundedUp(toNearest: .frames)
    /// // == "01:02:03:05.00" // rounds up to next whole frame
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundedUp(toNearest: .seconds)
    /// // == "01:02:04:00.00" // rounds up to next whole second
    /// ```
    ///
    /// - Throws: ``ValidationError`` if resulting timecode overflows.
    public func roundedUp(toNearest component: Timecode.Component) throws -> Timecode {
        var newTC = self
        try newTC.roundUp(toNearest: component)
        return newTC
    }
    
    // note: this comment block is identical to roundedUp() but has the method name changed
    
    /// Round the timecode up to the next whole component value if necessary.
    /// If all subsequently smaller component values are already 0 then no
    /// change is made of course.
    /// Passing ``Component/subFrames`` has no effect, as it is the smallest component.
    ///
    /// ie:
    ///
    /// ```
    /// try Timecode(.string("01:02:03:04.00"), at: ._24)
    ///     .roundUp(toNearest: .frames)
    /// // == "01:02:03:04.00" // no change
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundUp(toNearest: .frames)
    /// // == "01:02:03:05.00" // rounds up to next whole frame
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundUp(toNearest: .seconds)
    /// // == "01:02:04:00.00" // rounds up to next whole second
    /// ```
    ///
    /// - Throws: ``ValidationError`` if resulting timecode overflows.
    public mutating func roundUp(toNearest component: Timecode.Component) throws {
        switch component {
        case .days:
            if hours > 0 || minutes > 0 || seconds > 0 || frames > 0 || subFrames > 0 {
                try add(Components(d: 1))
                hours = 0
                minutes = 0
                seconds = 0
                frames = 0
                subFrames = 0
            }
        case .hours:
            if minutes > 0 || seconds > 0 || frames > 0 || subFrames > 0 {
                try add(Components(h: 1))
                minutes = 0
                seconds = 0
                frames = 0
                subFrames = 0
            }
        case .minutes:
            if seconds > 0 || frames > 0 || subFrames > 0 {
                try add(Components(m: 1))
                seconds = 0
                frames = 0
                subFrames = 0
            }
        case .seconds:
            if frames > 0 || subFrames > 0 {
                try add(Components(s: 1))
                frames = 0
                subFrames = 0
            }
        case .frames:
            if subFrames > 0 {
                try add(Components(f: 1))
                subFrames = 0
            }
        case .subFrames:
            // nothing to round, this is the smallest component
            break
        }
    }
    
    // MARK: - Truncate Subframes
    
    // note: this comment block is identical to roundDown() but has the method name changed
    
    /// Returns the timecode rounded down to the given component.
    /// If all subsequently smaller component values are already 0 then no
    /// change is made of course.
    /// Passing ``Component/subFrames`` has no effect, as it is the smallest component.
    ///
    /// ie:
    ///
    /// ```
    /// try Timecode(.string("01:02:03:04.00"), at: ._24)
    ///     .roundedDown(toNearest: .frames)
    /// // == "01:02:03:04.00" // no change
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundedDown(toNearest: .frames)
    /// // == "01:02:03:04.00" // subframes set to zero
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundedDown(toNearest: .seconds)
    /// // == "01:02:03:00.00" // frames and subframes set to zero
    /// ```
    public func roundedDown(toNearest component: Component) -> Self {
        var newTC = self
        newTC.roundDown(toNearest: component)
        return newTC
    }
    
    // note: this comment block is identical to roundedDown() but has the method name changed
    
    /// Truncates timecode after the given component and all subsequently smaller components.
    /// If all subsequently smaller component values are already 0 then no
    /// change is made of course.
    /// Passing ``Component/subFrames`` has no effect, as it is the smallest component.
    ///
    /// ie:
    ///
    /// ```
    /// try Timecode(.string("01:02:03:04.00"), at: ._24)
    ///     .roundDown(toNearest: .frames)
    /// // == "01:02:03:04.00" // no change
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundDown(toNearest: .frames)
    /// // == "01:02:03:04.00" // subframes set to zero
    ///
    /// try Timecode(.string("01:02:03:04.05"), at: ._24)
    ///     .roundDown(toNearest: .seconds)
    /// // == "01:02:03:00.00" // frames and subframes set to zero
    /// ```
    public mutating func roundDown(toNearest component: Component) {
        switch component {
        case .days:
            if hours > 0 { hours = 0 }
            fallthrough
        case .hours:
            if minutes > 0 { minutes = 0 }
            fallthrough
        case .minutes:
            if seconds > 0 { seconds = 0 }
            fallthrough
        case .seconds:
            if frames > 0 { frames = 0 }
            fallthrough
        case .frames:
            if subFrames > 0 { subFrames = 0 }
            fallthrough
        case .subFrames:
            // nothing to round, this is the smallest component
            break
        }
    }
}
