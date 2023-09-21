//
//  Timecode Source Protocols.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - Protocols

/// A protocol for timecode time value sources that do not supply their own frame
/// rate information.
public protocol TimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws
    
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule)
}

/// A protocol for formatted timecode time value sources that do not supply their own frame
/// rate information.
public protocol FormattedTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws
    
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) throws
}

/// A protocol for timecode time value sources that are able to supply frame rate information.
public protocol RichTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws -> Timecode.Properties
}

/// A protocol for timecode time value sources that are guaranteed to be valid regardless of properties.
public protocol GuaranteedTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode)
}

/// A protocol for timecode time value sources that are able to supply frame rate information and
/// are guaranteed to be valid regardless of properties.
public protocol GuaranteedRichTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) -> Timecode.Properties
}

// MARK: - Type Erasure

/// Box containing a concrete ``TimecodeSource`` instance.
public struct TimecodeSourceValue {
    internal var value: TimecodeSource
    
    internal init(value: TimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete ``FormattedTimecodeSource`` instance.
public struct FormattedTimecodeSourceValue {
    internal var value: FormattedTimecodeSource
    
    internal init(value: FormattedTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete ``RichTimecodeSource`` instance.
public struct RichTimecodeSourceValue {
    internal var value: RichTimecodeSource
    
    internal init(value: RichTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete ``GuaranteedTimecodeSource`` instance.
public struct GuaranteedTimecodeSourceValue {
    internal var value: GuaranteedTimecodeSource
    
    internal init(value: GuaranteedTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete ``GuaranteedRichTimecodeSource`` instance.
public struct GuaranteedRichTimecodeSourceValue {
    internal var value: GuaranteedRichTimecodeSource
    
    internal init(value: GuaranteedRichTimecodeSource) {
        self.value = value
    }
}