//
//  TimecodeFrameRate CompatibleGroup.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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
    /// - `01:00:00:00 @ 30 fps // group A`
    /// - `01:00:00:00 @ 60 fps // group A`
    /// - `00:59:56:12 @ 29.97 fps // group B`
    ///
    /// 30 and 60 fps both reach `01:00:00:00` at exactly the same time, then until the next timecode-second only the
    /// frame number will differ. They will then both reach `01:00:01:00` at exactly the same time, and so on.
    ///
    /// - note: These are intended for internal logic and not for end-user user interface.
    public enum CompatibleGroup: Equatable, Hashable, CaseIterable {
        case ntscColor
        case ntscDrop
        case whole
        case ntscColorWallTime
        
        /// Constants table of ``TimecodeFrameRate`` groups that share HH:MM:SS alignment between them.
        ///
        /// These groupings assert that amidst each group the hours, minutes, and seconds values will always be identical.
        /// Frames values may not literally match but will always correspond to the same duration of a timecode-second.
        ///
        /// For example:
        ///
        /// At 1 hour of elapsed real (wall-clock) time, 30 and 60 fps are compatible with each other, but 29.97 is not:
        /// - `01:00:00:00 @ 30 fps // group A`
        /// - `01:00:00:00 @ 60 fps // group A`
        /// - `00:59:56:12 @ 29.97 fps // group B`
        ///
        /// 30 and 60 fps both reach `01:00:00:00` at exactly the same time, then until the next timecode-second only the
        /// frame number will differ. They will then both reach `01:00:01:00` at exactly the same time, and so on.
        ///
        /// - note: These are intended for internal logic and not for end-user user interface.
        public static let table: [CompatibleGroup: [TimecodeFrameRate]] = [
            .ntscColor: [
                .fps23_976,
                .fps24_98,
                .fps29_97,
                .fps47_952,
                .fps59_94,
                .fps95_904,
                .fps119_88
            ],
            
            .ntscDrop: [
                .fps29_97d,
                .fps59_94d,
                .fps119_88d
            ],
        
            .whole: [
                .fps24,
                .fps25,
                .fps30,
                .fps48,
                .fps50,
                .fps60,
                .fps96,
                .fps100,
                .fps120
            ],
        
            .ntscColorWallTime: [
                .fps30d,
                .fps60d,
                .fps120d
            ]
        ]
    }
}

extension TimecodeFrameRate.CompatibleGroup: Sendable { }

extension TimecodeFrameRate.CompatibleGroup: CustomStringConvertible {
    public var description: String {
        stringValue
    }
    
    /// Returns human-readable group string.
    public var stringValue: String {
        switch self {
        case .ntscColor:
            "NTSC Color"
            
        case .ntscDrop:
            "NTSC Drop-Frame"
            
        case .whole:
            "Whole"
            
        case .ntscColorWallTime:
            "NTSC Color Wall Time"
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
    /// - `01:00:00:00 @ 30 fps // group A`
    /// - `01:00:00:00 @ 60 fps // group A`
    /// - `00:59:56:12 @ 29.97 fps // group B`
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
