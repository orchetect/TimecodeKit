//
//  Utilities.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if os(macOS)
import AppKit
#else
// import AudioToolbox
#endif

@available(iOS 16.0, *)
func beep() {
    #if os(macOS)
    NSSound.beep()
    #else
    // TODO: This uses a private constant value, which may cause App Store rejection
    // AudioServicesPlaySystemSound(1005)
    #endif
}
