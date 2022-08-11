//
//  FrameRate Sorted.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode.FrameRate {
    /// Internal: uses `allCases` to determine sort order.
    @inline(__always)
    fileprivate var sortOrderIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

extension Collection where Element == Timecode.FrameRate {
    /// Returns an array containing Elements logically sorted.
    public func sorted() -> [Element] {
        sorted { $0.sortOrderIndex < $1.sortOrderIndex }
    }
}
