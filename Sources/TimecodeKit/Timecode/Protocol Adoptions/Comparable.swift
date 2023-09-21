//
//  Comparable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Darwin
import Foundation

extension Timecode: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            ==
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}

extension Timecode: Comparable {
    /// Baseline linear comparison.
    ///
    /// This performs a face-value comparison that does not take timelines into consideration.
    ///
    /// ie:
    ///
    /// - `00:00:00:00 < 23:00:00:00 // true`
    /// - `23:00:00:00 < 00:00:00:00 // false`
    /// - `23:00:00:00 < 23:00:00:00 // false`
    ///
    /// For comparison based on a timeline that does not start at 00:00:00:00, see ``compare(to:timelineStart:)``.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            <
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}

extension Timecode {
    /// Compare two ``Timecode`` instances, optionally using a timeline that does not start at
    /// 00:00:00:00. Timeline length and wrap point is determined by the
    /// ``upperLimit-swift.property`` property. The timeline is considered linear for 24 hours (or
    /// 100 days) from this start time, wrapping around the upper limit.
    ///
    /// Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW
    /// software applications such as Pro Tools allows a project start time to be set to any
    /// timecode. Its timeline then extends for 24 hours from that timecode, wrapping around over
    /// 00:00:00:00 at some point along the timeline.
    ///
    /// Methods to sort and test sort order of `Timecode` collections are provided.
    ///
    /// For example, given a 24 hour limit:
    ///
    /// - A timeline start of 00:00:00:00:
    ///
    ///   24 hours elapses from 00:00:00:00 → 23:59:59:XX (where XX is max frame - 1)
    ///
    /// - A timeline start of 20:00:00:00:
    ///
    ///   24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:XX (where XX is max frame - 1)
    ///
    /// This would mean for example, that 21:00:00:00 is `<` 00:00:00:00 since it is earlier in the
    /// wrapping timeline, and 18:00:00:00 is `>` 21:00:00:00 since it is later in the wrapping
    /// timeline.
    ///
    /// Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the
    /// standard  `<`, `==`, or  `>` operators as a sort comparator.
    ///
    /// See also: ``TimecodeSortComparator``.
    public func compare(to other: Timecode, timelineStart: Timecode? = nil) -> ComparisonResult {
        // identical timecodes can early-return
        if self == other { return .orderedSame }
        
        guard let timelineStart = timelineStart, !timelineStart.isZero else {
            // standard operator compare will work if timeline start is nil or zero (both mean zero)
            if self < other { return .orderedAscending }
            else { return .orderedDescending }
        }
        
        // non-zero timeline start
        
        let timelineStartFrameCount = timelineStart.frameCount.decimalValue
        var lhsFrameCount = frameCount.decimalValue
        var rhsFrameCount = other.frameCount.decimalValue
        
        if lhsFrameCount >= timelineStartFrameCount {
            let lhsOneDay = Timecode(
                .components(d: 1),
                at: frameRate,
                base: subFramesBase,
                limit: ._100Days,
                by: .allowingInvalid
            )
            .frameCount.decimalValue
            lhsFrameCount -= lhsOneDay
        }
        if rhsFrameCount >= timelineStartFrameCount {
            let rhsOneDay = Timecode(
                .components(d: 1),
                at: other.frameRate,
                base: other.subFramesBase,
                limit: ._100Days,
                by: .allowingInvalid
            )
            .frameCount.decimalValue
            rhsFrameCount -= rhsOneDay
        }
        
        if lhsFrameCount < rhsFrameCount {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }
}

// MARK: - Collection Ordering

extension Collection where Element == Timecode {
    /// Returns `true` if all ``Timecode`` instances are ordered chronologically, either ascending
    /// or descending according to the `ascending` parameter.
    /// Contiguous subsequences of identical timecode are allowed.
    /// Timeline length and wrap point is determined by the ``Timecode/upperLimit-swift.property``
    /// property. The timeline is considered linear for 24 hours (or 100 days) from this start time,
    /// wrapping around the upper limit.
    ///
    /// Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW
    /// software applications such as Pro Tools allows a project start time to be set to any
    /// timecode. Its timeline then extends for 24 hours from that timecode, wrapping around over
    /// 00:00:00:00 at some point along the timeline.
    ///
    /// Methods to sort and test sort order of `Timecode` collections are provided.
    ///
    /// For example, given a 24 hour limit:
    ///
    /// - A timeline start of 00:00:00:00:
    ///
    ///   24 hours elapses from 00:00:00:00 → 23:59:59:XX (where XX is max frame - 1)
    ///
    /// - A timeline start of 20:00:00:00:
    ///
    ///   24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:XX (where XX is max frame - 1)
    ///
    /// This would mean for example, that 21:00:00:00 is `<` 00:00:00:00 since it is earlier in the
    /// wrapping timeline, and 18:00:00:00 is `>` 21:00:00:00 since it is later in the wrapping
    /// timeline.
    ///
    /// Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the
    /// standard  `<`, `==`, or  `>` operators as a sort comparator.
    ///
    /// See also: ``TimecodeSortComparator``.
    public func isSorted(
        ascending: Bool = true,
        timelineStart: Timecode? = nil
    ) -> Bool {
        guard count > 1 else { return true }
        
        var priorIdx = startIndex
        for idx in indices.dropFirst() {
            defer { priorIdx = idx }
            if self[idx] == self[priorIdx] { continue }
            let compared = self[priorIdx].compare(to: self[idx], timelineStart: timelineStart)
            if ascending {
                // orderedAscending is wanted
                // orderedSame is ok, even though we should never get it. (we already tested for equality)
                guard compared != .orderedDescending else { return false }
            } else {
                // orderedDescending is wanted
                // orderedSame is ok, even though we should never get it. (we already tested for equality)
                guard compared != .orderedAscending else { return false }
            }
        }
        
        return true
    }
}

extension Collection where Element == Timecode {
    /// Returns a collection sorting all ``Timecode`` instances chronologically, either ascending
    /// or descending.
    /// Contiguous subsequences of identical timecode are allowed.
    /// Timeline length and wrap point is determined by the ``Timecode/upperLimit-swift.property``
    /// property. The timeline is considered linear for 24 hours (or 100 days) from this start time,
    /// wrapping around the upper limit.
    ///
    /// Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW
    /// software applications such as Pro Tools allows a project start time to be set to any
    /// timecode. Its timeline then extends for 24 hours from that timecode, wrapping around over
    /// 00:00:00:00 at some point along the timeline.
    ///
    /// Methods to sort and test sort order of `Timecode` collections are provided.
    ///
    /// For example, given a 24 hour limit:
    ///
    /// - A timeline start of 00:00:00:00:
    ///
    ///   24 hours elapses from 00:00:00:00 → 23:59:59:XX (where XX is max frame - 1)
    ///
    /// - A timeline start of 20:00:00:00:
    ///
    ///   24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:XX (where XX is max frame - 1)
    ///
    /// This would mean for example, that 21:00:00:00 is `<` 00:00:00:00 since it is earlier in the
    /// wrapping timeline, and 18:00:00:00 is `>` 21:00:00:00 since it is later in the wrapping
    /// timeline.
    ///
    /// Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the
    /// standard  `<`, `==`, or  `>` operators as a sort comparator.
    ///
    /// See also: ``TimecodeSortComparator``.
    public func sorted(
        ascending: Bool = true,
        timelineStart: Timecode
    ) -> [Element] {
        sorted {
            $0.compare(to: $1, timelineStart: timelineStart)
                != (ascending ? .orderedDescending : .orderedAscending)
        }
    }
}

extension MutableCollection
    where Element == Timecode,
    Self: RandomAccessCollection,
    Element: Comparable
{
    /// Sorts the collection in place by sorting all ``Timecode`` instances chronologically, either
    /// ascending or descending.
    /// Contiguous subsequences of identical timecode are allowed.
    /// Timeline length and wrap point is determined by the ``Timecode/upperLimit-swift.property``
    /// property. The timeline is considered linear for 24 hours (or 100 days) from this start time,
    /// wrapping around the upper limit.
    ///
    /// Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW
    /// software applications such as Pro Tools allows a project start time to be set to any
    /// timecode. Its timeline then extends for 24 hours from that timecode, wrapping around over
    /// 00:00:00:00 at some point along the timeline.
    ///
    /// Methods to sort and test sort order of `Timecode` collections are provided.
    ///
    /// For example, given a 24 hour limit:
    ///
    /// - A timeline start of 00:00:00:00:
    ///
    ///   24 hours elapses from 00:00:00:00 → 23:59:59:XX (where XX is max frame - 1)
    ///
    /// - A timeline start of 20:00:00:00:
    ///
    ///   24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:XX (where XX is max frame - 1)
    ///
    /// This would mean for example, that 21:00:00:00 is `<` 00:00:00:00 since it is earlier in the
    /// wrapping timeline, and 18:00:00:00 is `>` 21:00:00:00 since it is later in the wrapping
    /// timeline.
    ///
    /// Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the
    /// standard  `<`, `==`, or  `>` operators as a sort comparator.
    ///
    /// See also: ``TimecodeSortComparator``.
    public mutating func sort(
        ascending: Bool = true,
        timelineStart: Timecode
    ) {
        sort {
            $0.compare(to: $1, timelineStart: timelineStart)
                != (ascending ? .orderedDescending : .orderedAscending)
        }
    }
}

/// Sort comparator for ``Timecode``, optionally supplying a timeline start time.
///
/// Contiguous subsequences of identical timecode are allowed.
/// Timeline length and wrap point is determined by the ``Timecode/upperLimit-swift.property``
/// property. The timeline is considered linear for 24 hours (or 100 days) from this start time,
/// wrapping around the upper limit.
///
/// Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW
/// software applications such as Pro Tools allows a project start time to be set to any
/// timecode. Its timeline then extends for 24 hours from that timecode, wrapping around over
/// 00:00:00:00 at some point along the timeline.
///
/// Methods to sort and test sort order of `Timecode` collections are provided.
///
/// For example, given a 24 hour limit:
///
/// - A timeline start of 00:00:00:00:
///
///   24 hours elapses from 00:00:00:00 → 23:59:59:XX (where XX is max frame - 1)
///
/// - A timeline start of 20:00:00:00:
///
///   24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:XX (where XX is max frame - 1)
///
/// This would mean for example, that 21:00:00:00 is `<` 00:00:00:00 since it is earlier in the
/// wrapping timeline, and 18:00:00:00 is `>` 21:00:00:00 since it is later in the wrapping
/// timeline.
///
/// Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the
/// standard  `<`, `==`, or  `>` operators as a sort comparator.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public struct TimecodeSortComparator: SortComparator {
    public typealias Compared = Timecode
    public var order: SortOrder
    
    public var timelineStart: Timecode?
    
    public func compare(_ lhs: Timecode, _ rhs: Timecode) -> ComparisonResult {
        let result = lhs.compare(to: rhs, timelineStart: timelineStart)
        switch order {
        case .forward:
            return result
        case .reverse:
            return result.inverted
        }
    }

    public init(order: SortOrder = .forward, timelineStart: Timecode? = nil) {
        self.order = order
        self.timelineStart = timelineStart
    }
}

extension ComparisonResult {
    /// Internal helper:
    /// Inverts the result if different from `orderedSame`.
    var inverted: Self {
        switch self {
        case .orderedAscending: return .orderedDescending
        case .orderedSame: return .orderedSame
        case .orderedDescending: return .orderedAscending
        }
    }
}
