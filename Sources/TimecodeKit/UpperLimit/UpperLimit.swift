//
//  UpperLimit.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

extension Timecode {
    
    /// Enum describing the maximum timecode ceiling.
    public enum UpperLimit: String, Codable {
        
        /// Pro Tools' upper limit is "23:59:59:FF" which is 1 day (24 hours) in duration.
        case _24hours = "24 hours"
        
        /// Cubase's upper limit is "99 23:59:59:FF" which is 100 days in duration.
        case _100days = "100 days"
        
        /// Internal use.
        @inlinable internal var maxDays: Int {
            
            switch self {
            case ._24hours: return 1
            case ._100days: return 100
            }
            
        }
        
        /// Internal use.
        @inlinable internal var maxDaysExpressible: Int {
            
            switch self {
            case ._24hours: return maxDays - 1
            case ._100days: return maxDays - 1
            }
            
        }
        
        /// Internal use.
        @inlinable internal var maxHours: Int {
            
            switch self {
            case ._24hours: return 24
            case ._100days: return 24
            }
            
        }
        
        /// Internal use.
        @inlinable internal var maxHoursExpressible: Int {
            
            switch self {
            case ._24hours: return maxHours - 1
            case ._100days: return maxHours - 1
            }
            
        }
        
        /// Internal use.
        @inlinable internal var maxHoursTotal: Int {
            
            switch self {
            case ._24hours: return maxDays - 1
            case ._100days: return (24 * maxDays) - 1
            }
            
        }
        
    }
    
}
