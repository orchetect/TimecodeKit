//
//  FrameRateProtocol Sorted.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

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
