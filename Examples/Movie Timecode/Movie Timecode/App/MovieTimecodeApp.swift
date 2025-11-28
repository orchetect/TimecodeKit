//
//  MovieTimecodeApp.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct MovieTimecodeApp: App {
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
        defaultSize(width: 680, height: 750)
            .defaultPosition(.center)
        #else
        self
        #endif
    }
}
