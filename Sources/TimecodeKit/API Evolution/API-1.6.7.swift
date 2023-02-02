//
//  API-1.6.7.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.6.7

// MARK: Timecode.FrameRate

extension VideoFrameRate {
    @available(*, deprecated, renamed: "_48p")
    public static let _48 = Self._48p
}
