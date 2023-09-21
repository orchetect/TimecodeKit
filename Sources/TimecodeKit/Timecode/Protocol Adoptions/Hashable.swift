//
//  Hashable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode: Hashable {
    // This relies on "enum FrameRate: Int"
    
    // To make the struct truly hashed, any crucial differentiating attributes must be encoded...
    // Max frames of 100 days @ 120fps ==
    //   0b11 1101 1100 1100 0101 0000 0000 0000 -- 30 bits
    
    public func hash(into hasher: inout Hasher) {
        // Add the frame rate information in bits above the total frames value; 30 places to the left so they don't overlap
        
        hasher.combine(frameCount)
        hasher.combine(frameRate.rawValue)
    }
}
