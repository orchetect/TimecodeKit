//
//  URL Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if os(macOS)
import AppKit
#endif

extension URL {
    /// Opens the file or folder with its associated viewer/editor application.
    /// If no application is associated, the file will be revealed in the Finder.
    /// Has no effect on non-macOS platforms.
    func openFile() throws {
        #if os(macOS)
        if !NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path()) {
            throw CocoaError(.fileNoSuchFile)
        }
        #endif
    }
    
    /// Reveals the file or folder in the Finder.
    /// Has no effect on non-macOS platforms.
    func revealInFinder() throws {
        #if os(macOS)
        if !NSWorkspace.shared.selectFile(path(), inFileViewerRootedAtPath: "/") {
            throw CocoaError(.fileNoSuchFile)
        }
        #endif
    }
}
