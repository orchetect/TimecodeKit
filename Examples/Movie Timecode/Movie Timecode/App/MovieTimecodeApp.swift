//
//  MovieTimecodeApp.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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
            self
                .windowIdealSize(.fitToContent)
                .defaultPosition(.center)
        #else
            self
        #endif
    }
}
