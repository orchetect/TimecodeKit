//
//  Timecode Validation.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    public enum ValidationRule: Equatable, Hashable, CaseIterable {
        /// Clamp timecode to valid timecode range if necessary.
        case clamping
        
        /// Clamp individual components if necessary.
        case clampingComponents
        
        /// Wrap over or under the valid timecode range if necessary.
        case wrapping
        
        /// Raw values are preserved without any validation.
        case allowingInvalid
    }
}

extension Timecode {
    /// Returns a set of invalid components, if any.
    /// A fully valid timecode will return an empty set.
    /// Validation relies on `frameRate` and `upperLimit`.
    public var invalidComponents: Set<Component> {
        components.invalidComponents(
            using: properties
        )
    }
}

extension Timecode {
    /// Returns `true` if the timecode is valid given the current ``frameRate``, ``upperLimit-swift.property``, and
    /// ``subFramesBase-swift.property``.
    public var isValid: Bool {
        invalidComponents.isEmpty
    }
}

extension Timecode {
    /// Returns valid range of values for a timecode component, given the current ``frameRate``,
    /// ``upperLimit-swift.property``, and ``subFramesBase-swift.property``.
    ///
    /// > Note:
    /// >
    /// > This method is context-sensitive and oriented toward validation based on the current component values and
    /// > properties.
    /// >
    /// > For example, if the frame rate is a drop-frame rate and the current `minutes` are divisible by `10` and the
    /// > current `seconds` are `0` then this method will return a valid `frames` range of `2 ... X` where `X` is the
    /// > maximum frame number expressible.
    public func validRange(of component: Component) -> ClosedRange<Int> {
        components.validRange(of: component, using: properties)
    }
}

extension Timecode.Components {
    /// Returns valid range of values for a timecode component using the specified properties.
    ///
    /// > Note:
    /// >
    /// > This method is context-sensitive and oriented toward validation based on the current component values and
    /// > properties.
    /// >
    /// > For example, if the frame rate is a drop-frame rate and the current `minutes` are divisible by `10` and the
    /// > current `seconds` are `0` then this method will return a valid `frames` range of `2 ... X` where `X` is the
    /// > maximum frame number expressible.
    public func validRange(
        of component: Timecode.Component,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) -> ClosedRange<Int> {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        return validRange(of: component, using: properties)
    }
    
    /// Returns valid range of values for a timecode component using the specified properties.
    ///
    /// > Note:
    /// >
    /// > This method is context-sensitive and oriented toward validation based on the current component values and
    /// > properties.
    /// >
    /// > For example, if the frame rate is a drop-frame rate and the current `minutes` are divisible by `10` and the
    /// > current `seconds` are `0` then this method will return a valid `frames` range of `2 ... X` where `X` is the
    /// > maximum frame number expressible.
    public func validRange(
        of component: Timecode.Component,
        using properties: Timecode.Properties
    ) -> ClosedRange<Int> {
        switch component {
        case .days:
            return 0 ... properties.upperLimit.maxDaysExpressible
            
        case .hours:
            return 0 ... 23
            
        case .minutes:
            return 0 ... 59
            
        case .seconds:
            return 0 ... 59
            
        case .frames:
            let startFramePossible = properties.frameRate.isDrop
                ? ((minutes % 10 != 0 && seconds == 0) ? 2 : 0)
                : 0
            
            return startFramePossible ... properties.frameRate.maxFrameNumberDisplayable
            
        case .subFrames:
            // clamp divisor to prevent a possible crash if subFramesBase < 0
            return 0 ... (properties.subFramesBase.rawValue.clamped(to: 1...) - 1)
        }
    }
}

extension Timecode {
    mutating func _clamp(component: Component) {
        switch component {
        case .days:
            days = days.clamped(to: validRange(of: .days))
            
        case .hours:
            hours = hours.clamped(to: validRange(of: .hours))
            
        case .minutes:
            minutes = minutes.clamped(to: validRange(of: .minutes))
            
        case .seconds:
            seconds = seconds.clamped(to: validRange(of: .seconds))
            
        case .frames:
            frames = frames.clamped(to: validRange(of: .frames))
            
        case .subFrames:
            subFrames = subFrames.clamped(to: validRange(of: .subFrames))
        }
    }
}

extension Timecode {
    /// Validates and clamps all timecode components to valid values at the current `frameRate` and
    /// `upperLimit` bound.
    ///
    /// This is not necessary to be run manually if the instance was initialized using the ``ValidationRule/clamping`` or
    /// ``ValidationRule/clampingComponents`` validation rule.
    public mutating func clampComponents() {
        _clamp(component: .days)
        _clamp(component: .hours)
        _clamp(component: .minutes)
        _clamp(component: .seconds)
        _clamp(component: .frames)
        _clamp(component: .subFrames)
    }
}

extension Timecode {
    /// Returns `true` if all component values are within acceptable number of digit range based on the instance's frame
    /// rate and subframes base.
    ///
    /// > NOTE:
    /// > This method does not validate the values themselves, but merely the number of digit places they occupy.
    /// >
    /// > For example, the `frames` value could be `99` which is an invalid value at most frame rates, however it is
    /// > still within the allowable digit count for those frame rates (2 digit places).
    /// >
    /// > To validate timecode component values, query the ``isValid`` property instead. Alternatively, the
    /// > ``invalidComponents`` property can granularly return which individual components are invalid, if any.
    public var isWithinValidComponentDigitCounts: Bool {
        components.isWithinValidDigitCounts(at: frameRate, base: subFramesBase)
    }
}

extension Timecode {
    /// Returns the largest subframe value displayable before rolling over to the next frame.
    public var maxSubFramesExpressible: Int {
        validRange(of: .subFrames)
            .upperBound
    }
    
    /// Returns the `upperLimit` minus 1 subframe expressed as frames where the integer portion is
    /// whole frames and the fractional portion is the subframes unit interval.
    public var maxFrameCountExpressible: FrameCount {
        FrameCount(
            .split(
                frames: frameRate.maxTotalFramesExpressible(in: upperLimit),
                subFrames: maxSubFramesExpressible
            ),
            base: subFramesBase
        )
    }
    
    /// Returns the `upperLimit` minus 1 subframe expressed as total subframes.
    public var maxSubFrameCountExpressible: Int {
        frameRate.maxSubFrameCountExpressible(
            in: upperLimit,
            base: subFramesBase
        )
    }
}
