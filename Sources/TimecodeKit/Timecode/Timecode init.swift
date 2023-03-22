//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - Basic
    
    /// Initialize by converting a time source to timecode at the given frame rate.
    /// Uses defaulted properties.
    public init(
        _ source: Source,
        at frameRate: TimecodeFrameRate
    ) throws {
        properties = Properties(rate: frameRate)
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode at the given frame rate.
    /// Uses defaulted properties.
    public init(
        _ source: Source,
        at frameRate: TimecodeFrameRate,
        by validation: Validation
    ) {
        properties = Properties(rate: frameRate)
        set(source, by: validation)
    }
    
    /// Initialize by converting a time source to timecode.
    public init(
        _ source: Source,
        using properties: Properties
    ) throws {
        self.properties = properties
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode.
    public init(
        _ source: Source,
        using properties: Properties,
        by validation: Validation
    ) {
        self.properties = properties
        set(source, by: validation)
    }
    
    /// Initialize with zero timecode (00:00:00:00) at a given frame rate.
    public init(
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
    }
    
    /// Initialize with zero timecode (00:00:00:00) at a given frame rate.
    public init(
        using properties: Properties
    ) {
        self.properties = properties
    }
    
    
    
    
    
    
    // MARK: - TimecodeInterval
    #warning("> refactor into Source case or static constructor")
    
    /// Instance by flattening a `TimecodeInterval`, wrapping as necessary based on the
    /// ``upperLimit-swift.property`` and ``frameRate-swift.property`` of the interval.
    public init(
        flattening interval: TimecodeInterval
    ) {
        self = interval.flattened()
    }
}
