//
//  TimecodeUIApp.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct TimecodeUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
        }
        .windowModifiersForMacOS()
    }
}

extension Scene {
    func windowModifiersForMacOS() -> some Scene {
        #if os(macOS)
        defaultSize(width: 920, height: 950)
            .defaultPosition(.center)
        #else
        self
        #endif
    }
}
