//
//  CustomStringConvertible.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        stringValue(format: [.showSubFrames])
    }
    
    public var debugDescription: String {
        // include Days even if it's 0 if we have a mode set that enables Days
        var format: Timecode.StringFormat = [.showSubFrames]
        if upperLimit == .max100Days { format.insert(.alwaysShowDays) }
        return "Timecode<\(stringValue(format: format)) @ \(frameRate.stringValueVerbose)>"
    }
}
