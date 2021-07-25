//
//  Comparable.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

extension Timecode: Equatable {
    
    @inlinable static public func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.realTimeValue.rounded(decimalPlaces: 9) == rhs.realTimeValue.rounded(decimalPlaces: 9)
        
    }
    
}

extension Timecode: Comparable {
    
    @inlinable static public func < (lhs: Self, rhs: Self) -> Bool {
        
        lhs.realTimeValue.rounded(decimalPlaces: 9) < rhs.realTimeValue.rounded(decimalPlaces: 9)
        
    }
    
}
