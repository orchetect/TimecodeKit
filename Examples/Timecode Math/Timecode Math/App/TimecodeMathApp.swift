//
//  TimecodeMathApp.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct TimecodeMathApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowModifiersForMacOS()
    }
}

extension Scene {
    func windowModifiersForMacOS() -> some Scene {
        #if os(macOS)
        defaultSize(width: 360, height: 530)
            .windowResizability(.contentSize)
            .defaultPosition(.center)
        #else
        self
        #endif
    }
}
