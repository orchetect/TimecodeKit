//
//  Codable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode: Codable {
    enum CodingKeys: String, CodingKey {
        case frameRate
        case upperLimit
        case subFramesBase
        case stringFormat // deprecated in TimecodeKit 2.0
        
        case days
        case hours
        case minutes
        case seconds
        case frames
        case subFrames
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(properties.frameRate, forKey: .frameRate)
        try container.encode(properties.upperLimit, forKey: .upperLimit)
        try container.encode(properties.subFramesBase, forKey: .subFramesBase)
        
        try container.encode(components.days, forKey: .days)
        try container.encode(components.hours, forKey: .hours)
        try container.encode(components.minutes, forKey: .minutes)
        try container.encode(components.seconds, forKey: .seconds)
        try container.encode(components.frames, forKey: .frames)
        try container.encode(components.subFrames, forKey: .subFrames)
        
        // skip stringFormat; deprecated in TimecodeKit 2.0
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        properties = try Properties(
            rate: values.decode(TimecodeFrameRate.self, forKey: .frameRate),
            base: values.decode(SubFramesBase.self, forKey: .subFramesBase),
            limit: values.decode(UpperLimit.self, forKey: .upperLimit)
        )
        
        components = try Components(
            d: values.decode(Int.self, forKey: .days),
            h: values.decode(Int.self, forKey: .hours),
            m: values.decode(Int.self, forKey: .minutes),
            s: values.decode(Int.self, forKey: .seconds),
            f: values.decode(Int.self, forKey: .frames),
            sf: values.decode(Int.self, forKey: .subFrames)
        )
        
        // skip stringFormat; deprecated in TimecodeKit 2.0
    }
}
