//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - Basic
    
    /// Instance with default timecode (00:00:00:00) at a given frame rate.
    public init(
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
    }
    
    // MARK: - TimecodeInterval
    
    /// Instance by flattening a `TimecodeInterval`, wrapping as necessary based on the ``upperLimit-swift.property`` and ``frameRate-swift.property`` of the interval.
    public init(
        flattening interval: TimecodeInterval
    ) {
        self = interval.flattened()
    }
    
    // ------------------------------------------------------
    // For additional inits, see the Data Interchange folder.
    // ------------------------------------------------------
}
