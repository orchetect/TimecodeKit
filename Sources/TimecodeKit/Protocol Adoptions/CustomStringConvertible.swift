//
//  CustomStringConvertible.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode: CustomStringConvertible, CustomDebugStringConvertible {
    
    @inlinable public var description: String {
        
        stringValue
        
    }
    
    public var debugDescription: String {
        
        // include Days even if it's 0 if we have a mode set that enables Days
        let daysString =
            upperLimit == ._100days
            ? "\(days):"
            : ""
        
        return "Timecode<\(daysString)\(stringValue) @ \(frameRate.stringValue)>"
        
    }
    
    public var verboseDescription: String {
        
        "\(stringValue) @ \(frameRate.stringValue)"
        
    }
    
}
