//
//  Comparable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode: Equatable {
    
    @inlinable static public func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            ==
            rhs.realTimeValue.rounded(decimalPlaces: 9)
        
    }
    
}

extension Timecode: Comparable {
    
    @inlinable static public func < (lhs: Self, rhs: Self) -> Bool {
        
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            <
            rhs.realTimeValue.rounded(decimalPlaces: 9)
        
    }
    
}
