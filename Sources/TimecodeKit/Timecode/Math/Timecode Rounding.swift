//
//  Timecode Rounding.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Rounding
    
    /// Returns the timecode rounded up to the next whole frame if `subFrames > 0`.
    /// If `subframes == 0` then `self` is returned unchanged.
    ///
    /// - Throws: ``ValidationError`` if resulting timecode overflows.
    public func roundedUpToNextWholeFrame() throws -> Timecode {
        guard subFrames > 0 else { return self }
        var newTC = self
        try newTC.roundUpToNextWholeFrame()
        return newTC
    }
    
    /// Rounded the timecode up to the next whole frame if `subFrames > 0`.
    /// If `subframes == 0` then the timecode remains unchanged.
    ///
    /// - Throws: ``ValidationError`` if resulting timecode overflows.
    public mutating func roundUpToNextWholeFrame() throws {
        guard subFrames > 0 else { return }
        try add(TCC(f: 1))
        truncateSubFrames()
    }
    
    // MARK: - Truncate Subframes
    
    /// Returns the timecode with `subFrames` truncated (sets subFrames to 0).
    public func truncatingSubFrames() -> Self {
        guard subFrames > 0 else { return self }
        var newTC = self
        newTC.truncateSubFrames()
        return newTC
    }
    
    /// Truncates `subFrames` (sets subFrames to 0).
    public mutating func truncateSubFrames() {
        guard subFrames > 0 else { return }
        subFrames = 0
    }
}
