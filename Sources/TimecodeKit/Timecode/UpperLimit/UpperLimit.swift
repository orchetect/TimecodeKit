//
//  UpperLimit.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Enum describing the maximum timecode ceiling.
    public enum UpperLimit: String, CaseIterable {
        /// Pro Tools' upper limit is "23:59:59:FF" inclusive, which is 1 day (24 hours) in duration.
        case max24Hours = "24 hours"
        
        /// Cubase's upper limit is "99 23:59:59:FF" inclusive, which is 100 days in duration.
        case max100Days = "100 days"
        
        /// Internal use.
        var maxDays: Int {
            switch self {
            case .max24Hours: return 1
            case .max100Days: return 100
            }
        }
        
        /// Internal use.
        var maxDaysExpressible: Int {
            switch self {
            case .max24Hours: return maxDays - 1
            case .max100Days: return maxDays - 1
            }
        }
        
        /// Internal use.
        var maxHours: Int {
            switch self {
            case .max24Hours: return 24
            case .max100Days: return 24
            }
        }
        
        /// Internal use.
        var maxHoursExpressible: Int {
            switch self {
            case .max24Hours: return maxHours - 1
            case .max100Days: return maxHours - 1
            }
        }
        
        /// Internal use.
        var maxHoursTotal: Int {
            switch self {
            case .max24Hours: return maxHours - 1
            case .max100Days: return (maxHours * maxDays) - 1
            }
        }
    }
}

extension Timecode.UpperLimit: Codable { }
