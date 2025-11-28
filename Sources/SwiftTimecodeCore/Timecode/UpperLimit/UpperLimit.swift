//
//  UpperLimit.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Enum describing the maximum timecode ceiling.
    public enum UpperLimit: String, CaseIterable {
        /// 24-hour upper limit.
        /// Pro Tools' upper limit is "23:59:59:FF" inclusive, which is 1 day (24 hours) in duration.
        case max24Hours = "24 hours"
        
        /// 100-day upper limit.
        /// Cubase's upper limit is "99 23:59:59:FF" inclusive, which is 100 days in duration.
        case max100Days = "100 days"
    }
}

extension Timecode.UpperLimit: Sendable { }

extension Timecode.UpperLimit: Codable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.UpperLimit: Identifiable {
    public var id: Self { self }
}

// MARK: - Methods

extension Timecode.UpperLimit {
    /// Internal use.
    var maxDays: Int {
        switch self {
        case .max24Hours: 1
        case .max100Days: 100
        }
    }
    
    /// Internal use.
    var maxDaysExpressible: Int {
        switch self {
        case .max24Hours: maxDays - 1
        case .max100Days: maxDays - 1
        }
    }
    
    /// Internal use.
    var maxHours: Int {
        switch self {
        case .max24Hours: 24
        case .max100Days: 24
        }
    }
    
    /// Internal use.
    var maxHoursExpressible: Int {
        switch self {
        case .max24Hours: maxHours - 1
        case .max100Days: maxHours - 1
        }
    }
    
    /// Internal use.
    var maxHoursTotal: Int {
        switch self {
        case .max24Hours: maxHours - 1
        case .max100Days: (maxHours * maxDays) - 1
        }
    }
}
