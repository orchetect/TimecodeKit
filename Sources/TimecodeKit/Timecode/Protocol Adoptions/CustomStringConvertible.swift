//
//  CustomStringConvertible.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        stringValue()
    }
    
    public var debugDescription: String {
        // include Days even if it's 0 if we have a mode set that enables Days
        let daysString =
            properties.upperLimit == ._100days
                ? "\(components.days):"
                : ""
        
        return "Timecode<\(daysString)\(stringValue(format: .showSubFrames)) @ \(properties.frameRate.stringValueVerbose)>"
    }
    
    public var verboseDescription: String {
        "\(stringValue(format: .showSubFrames)) @ \(properties.frameRate.stringValueVerbose)"
    }
}
