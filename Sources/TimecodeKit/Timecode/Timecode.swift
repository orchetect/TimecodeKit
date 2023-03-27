//
//  Timecode.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Value type representing SMPTE timecode.
///
/// - A variety of initializers and methods are available for string and numeric representation, validation, and conversion
/// - Mathematical operators are available between two instances: `+`, `-`, `*`, `\`
/// - Comparison operators are available between two instances: `==`, `!=`, `<`, `>`
/// - `Range` and `Stride` can be formed between two instances
public struct Timecode {
    /// Timecode components.
    public var components: Components = .zero
    
    /// Timecode properties.
    public var properties: Properties
}

#warning("> custom implement Codable to match TimecodeKit V1's raw codable format")
// Can't put this in another file since it prevents automatic synthesis
// But for sake of consistency, we'll put it on an extension here since all other
// protocol conformances exist in separate files. Sad panda.
extension Timecode: Codable { }
