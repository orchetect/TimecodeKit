//
//  CustomStringConvertible.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        stringValue()
    }
    
    public var debugDescription: String {
        // include Days even if it's 0 if we have a mode set that enables Days
        let daysString =
            upperLimit == .max100Days
                ? "\(days):"
                : ""
        
        return "Timecode<\(daysString)\(stringValue(format: .showSubFrames)) @ \(frameRate.stringValueVerbose)>"
    }
    
    public var verboseDescription: String {
        "\(stringValue(format: .showSubFrames)) @ \(frameRate.stringValueVerbose)"
    }
}
