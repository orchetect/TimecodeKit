//
//  PathView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import SwiftUI

/// SwiftUI view wrapper for `NSPathControl`.
struct PathView: NSViewRepresentable {
    public let url: URL?
    public let style: NSPathControl.Style
    public let isEditable: Bool
    
    public init(
        url: URL,
        style: NSPathControl.Style,
        isEditable: Bool = false
    ) {
        self.url = url
        self.style = style
        self.isEditable = isEditable
    }
    
    // MARK: - NSViewRepresentable overrides
    
    func makeNSView(context: NSViewRepresentableContext<PathView>) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.target = context.coordinator
        pathControl.action = #selector(Coordinator.action)
        pathControl.focusRingType = .none
        pathControl.pathStyle = style
        pathControl.isEditable = isEditable
        return pathControl
    }
    
    func updateNSView(
        _ nsView: NSPathControl,
        context: NSViewRepresentableContext<PathView>
    ) {
        nsView.url = url
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NSPathControlDelegate {
        @objc
        func action(sender: NSPathControl) {
            // reveal file/folder in Finder
            let url = sender.clickedPathItem?.url
            try? url?.revealInFinder()
        }
    }
}

#endif
