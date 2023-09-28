//
//  Timecode Source Protocols.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - Protocols

/// A protocol for timecode time value sources that do not supply their own frame
/// rate information.
protocol _TimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws
    
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule)
}

/// A protocol for formatted timecode time value sources that do not supply their own frame
/// rate information.
protocol _FormattedTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws
    
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) throws
}

/// A protocol for timecode time value sources that are able to supply frame rate information.
protocol _RichTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) throws -> Timecode.Properties
}

/// A protocol for timecode time value sources that are guaranteed to be valid regardless of properties.
protocol _GuaranteedTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode)
}

/// A protocol for timecode time value sources that are able to supply frame rate information and
/// are guaranteed to be valid regardless of properties.
protocol _GuaranteedRichTimecodeSource {
    /// Sets the timecode for a ``Timecode`` instance from a time value source.
    /// Not meant to be called directly; instead, pass this instance into a ``Timecode`` initializer.
    func set(timecode: inout Timecode) -> Timecode.Properties
}

// MARK: - Type Erasure

/// Box containing a concrete `TimecodeSource` instance.
///
/// > Note:
/// > This struct is not designed to be used directly. Use the static construction methods to form a value instead.
/// > See ``Timecode`` for more details and examples.
public struct TimecodeSourceValue {
    var value: _TimecodeSource
    
    init(value: _TimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete `FormattedTimecodeSource` instance.
///
/// > Note:
/// > This struct is not designed to be used directly. Use the static construction methods to form a value instead.
/// > See ``Timecode`` for more details and examples.
public struct FormattedTimecodeSourceValue {
    var value: _FormattedTimecodeSource
    
    init(value: _FormattedTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete `RichTimecodeSource` instance.
///
/// > Note:
/// > This struct is not designed to be used directly. Use the static construction methods to form a value instead.
/// > See ``Timecode`` for more details and examples.
public struct RichTimecodeSourceValue {
    var value: _RichTimecodeSource
    
    init(value: _RichTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete `GuaranteedTimecodeSource` instance.
///
/// > Note:
/// > This struct is not designed to be used directly. Use the static construction methods to form a value instead.
/// > See ``Timecode`` for more details and examples.
public struct GuaranteedTimecodeSourceValue {
    var value: _GuaranteedTimecodeSource
    
    init(value: _GuaranteedTimecodeSource) {
        self.value = value
    }
}

/// Box containing a concrete `GuaranteedRichTimecodeSource` instance.
///
/// > Note:
/// > This struct is not designed to be used directly. Use the static construction methods to form a value instead.
/// > See ``Timecode`` for more details and examples.
public struct GuaranteedRichTimecodeSourceValue {
    var value: _GuaranteedRichTimecodeSource
    
    init(value: _GuaranteedRichTimecodeSource) {
        self.value = value
    }
}
