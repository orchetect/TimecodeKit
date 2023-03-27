//
//  Codable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
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
        try container.encode(components.subFrames, forKey: .subFrames)
        
        // skip stringFormat; deprecated in TimecodeKit 2.0
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        properties = Properties(
            rate: try values.decode(TimecodeFrameRate.self, forKey: .frameRate),
            base: try values.decode(SubFramesBase.self, forKey: .subFramesBase),
            limit: try values.decode(UpperLimit.self, forKey: .upperLimit)
        )
        
        components = Components(
            d: try values.decode(Int.self, forKey: .days),
            h: try values.decode(Int.self, forKey: .hours),
            m: try values.decode(Int.self, forKey: .minutes),
            s: try values.decode(Int.self, forKey: .seconds),
            f: try values.decode(Int.self, forKey: .frames),
            sf: try values.decode(Int.self, forKey: .subFrames)
        )
        
        // skip stringFormat; deprecated in TimecodeKit 2.0
    }
}
