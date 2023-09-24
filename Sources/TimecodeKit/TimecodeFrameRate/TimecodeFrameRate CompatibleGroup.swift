//
//  TimecodeFrameRate CompatibleGroup.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension TimecodeFrameRate {
    /// Enum describing compatible groupings of frame rates.
    ///
    /// These groupings assert that amidst each group the hours, minutes, and seconds values will always be identical.
    /// Frames values may not literally match but will always correspond to the same duration of a timecode-second.
    ///
    /// For example:
    ///
    /// At 1 hour of elapsed real (wall-clock) time, 30 and 60 fps are compatible with each other, but 29.97 is not:
    /// - `01:00:00:00 @ 30 fps // NTSC Non-Drop`
    /// - `01:00:00:00 @ 60 fps // NTSC Non-Drop`
    /// - `00:59:56:12 @ 29.97 fps // NTSC Drop`
    ///
    /// 30 and 60 fps both reach `01:00:00:00` at exactly the same time, then until the next timecode-second only the
    /// frame number will differ. They will then both reach `01:00:01:00` at exactly the same time, and so on.
    ///
    /// - note: These are intended for internal logic and not for end-user user interface.
    public enum CompatibleGroup: Equatable, Hashable, CaseIterable {
        case ntsc
        case ntscDrop
        case atsc
        case atscDrop
        
        /// Constants table of ``TimecodeFrameRate`` groups that share HH:MM:SS alignment between them.
        ///
        /// These groupings assert that amidst each group the hours, minutes, and seconds values will always be identical.
        /// Frames values may not literally match but will always correspond to the same duration of a timecode-second.
        ///
        /// For example:
        ///
        /// At 1 hour of elapsed real (wall-clock) time, 30 and 60 fps are compatible with each other, but 29.97 is not:
        /// - `01:00:00:00 @ 30 fps // NTSC Non-Drop`
        /// - `01:00:00:00 @ 60 fps // NTSC Non-Drop`
        /// - `00:59:56:12 @ 29.97 fps // NTSC Drop`
        ///
        /// 30 and 60 fps both reach `01:00:00:00` at exactly the same time, then until the next timecode-second only the
        /// frame number will differ. They will then both reach `01:00:01:00` at exactly the same time, and so on.
        ///
        /// - note: These are intended for internal logic and not for end-user user interface.
        public static var table: [CompatibleGroup: [TimecodeFrameRate]] =
            [
                .ntsc: [
                    ._23_976,
                    ._24_98,
                    ._29_97,
                    ._47_952,
                    ._59_94,
                    ._95_904,
                    ._119_88
                ],
                
                .ntscDrop: [
                    ._29_97_drop,
                    ._59_94_drop,
                    ._119_88_drop
                ],
                
                .atsc: [
                    ._24,
                    ._25,
                    ._30,
                    ._48,
                    ._50,
                    ._60,
                    ._96,
                    ._100,
                    ._120
                ],
                
                .atscDrop: [
                    ._30_drop,
                    ._60_drop,
                    ._120_drop
                ]
            ]
    }
}

extension TimecodeFrameRate.CompatibleGroup: CustomStringConvertible {
    public var description: String {
        stringValue
    }
    
    /// Returns human-readable group string.
    public var stringValue: String {
        switch self {
        case .ntsc:
            return "NTSC"
            
        case .ntscDrop:
            return "NTSC Drop-Frame"
            
        case .atsc:
            return "ATSC"
            
        case .atscDrop:
            return "ATSC Drop-Frame"
        }
    }
}

extension TimecodeFrameRate {
    /// Returns the frame rate's ``CompatibleGroup`` categorization.
    public var compatibleGroup: CompatibleGroup {
        // Force-unwrap here will never crash because the unit tests ensure the table contains all TimecodeFrameRate cases.
        
        Self.CompatibleGroup.table
            .lazy
            .first(where: { $0.value.contains(self) })!
            .key
    }
    
    /// Returns the members of the frame rate's ``CompatibleGroup`` categorization.
    public var compatibleGroupRates: [Self] {
        // Force-unwrap here will never crash because the unit tests ensure the table contains all TimecodeFrameRate cases.
        
        Self.CompatibleGroup.table
            .lazy
            .first(where: { $0.value.contains(self) })!
            .value
    }
    
    /// Returns true if the source ``TimecodeFrameRate`` shares a compatible grouping with the passed `other` frame rate.
    ///
    /// These groupings assert that amidst each group the hours, minutes, and seconds values will always be identical.
    /// Frames values may not literally match but will always correspond to the same duration of a timecode-second.
    ///
    /// For example:
    ///
    /// At 1 hour of elapsed real (wall-clock) time, 30 and 60 fps are compatible with each other, but 29.97 is not:
    /// - `01:00:00:00 @ 30 fps // NTSC Non-Drop`
    /// - `01:00:00:00 @ 60 fps // NTSC Non-Drop`
    /// - `00:59:56:12 @ 29.97 fps // NTSC Drop`
    ///
    /// 30 and 60 fps both reach `01:00:00:00` at exactly the same time, then until the next timecode-second only the
    /// frame number will differ. They will then both reach `01:00:01:00` at exactly the same time, and so on.
    ///
    /// - note: These are intended for internal logic and not for end-user user interface.
    public func isCompatible(with other: Self) -> Bool {
        Self.CompatibleGroup.table
            .values
            .lazy
            .first(where: { $0.contains(self) })?
            .contains(other)
            ?? false
    }
}
