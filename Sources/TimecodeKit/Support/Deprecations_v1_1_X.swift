//
//  Deprecations_v1_1_X.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

// MARK: - Formatter/TextFormatter.swift

extension Timecode.TextFormatter {
    
    /// Changed in TimecodeKit 1.1.?
    @available(swift, obsoleted: 0.1, renamed: "timecodeTemplate")
    public var timecodeWithProperties: Timecode?
    { fatalError() } // never runs but prevents compiler from complaining
    
}
