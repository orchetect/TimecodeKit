//
//  FrameRateProtocol Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: Sorted

extension FrameRateProtocol {
    /// Internal: uses `allCases` to determine sort order.
    fileprivate var sortOrderIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

extension Collection where Element: FrameRateProtocol {
    /// Returns an array containing Elements logically sorted.
    public func sorted() -> [Element] {
        sorted { $0.sortOrderIndex < $1.sortOrderIndex }
    }
}

// MARK: Utils

extension Collection where Element: FrameRateProtocol {
    /// Internal:
    /// Filters collection to rates that match the given rational rate fraction.
    internal func filter(
        rationalRate: (numerator: Int, denominator: Int)
    ) -> [Element] {
        filter {
            let lhsFrac = $0.rationalRate
            
            let isLiteralMatch = lhsFrac.numerator == rationalRate.numerator
            && lhsFrac.denominator == rationalRate.denominator
            
            let lhsFPS = Double(lhsFrac.numerator) / Double(lhsFrac.denominator)
            let rhsFPS = Double(rationalRate.numerator) / Double(rationalRate.denominator)
            let isFPSMatch = lhsFPS == rhsFPS
            
            return isLiteralMatch || isFPSMatch
        }
    }
}
