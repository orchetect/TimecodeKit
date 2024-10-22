//
//  Utilities.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent {
    static let num0 = Self("0")
    static let num1 = Self("1")
    static let num2 = Self("2")
    static let num3 = Self("3")
    static let num4 = Self("4")
    static let num5 = Self("5")
    static let num6 = Self("6")
    static let num7 = Self("7")
    static let num8 = Self("8")
    static let num9 = Self("9")
    
    static let period = Self(".")
    static let comma = Self(",")
    static let colon = Self(":")
    static let semicolon = Self(";")
    
    static let a = Self("A")
}

#endif
