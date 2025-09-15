//
//  OpenPanel.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import AppKit
import SwiftUI

extension NSOpenPanel {
    public convenience init(
        allowsMultipleSelection: Bool,
        allowFiles: Bool,
        allowDirectories: Bool
    ) {
        self.init()
        self.allowsMultipleSelection = allowsMultipleSelection
        self.canChooseDirectories = allowFiles
        self.canChooseFiles = allowFiles
    }
    
    public func present(
        completion: @MainActor @escaping (_ urls: [URL]?) -> Void
    ) {
        var selectedURLs: [URL]?
        
        // runModal() must be called asynchronously or we get a runtime exception on macOS 26
        Task { @MainActor in
            if runModal() == .OK {
                selectedURLs = urls
            }
            
            completion(selectedURLs)
        }
    }
}

@MainActor
public struct OpenPanelView<Content: View>: View {
    @Binding public var isPresented: Bool
    public let setup: ((_ panel: NSOpenPanel) -> Void)?
    public let completion: @MainActor (_ urls: [URL]) -> Void
    public let content: Content
    
    @State private var panel: NSOpenPanel?
    
    public var body: some View {
        content
            .onChange(of: isPresented) { newValue in
                newValue ? present() : close()
            }
    }
    
    private func present() {
        let newPanel = NSOpenPanel()
        setup?(newPanel)
        panel = newPanel
        
        isPresented = true
        
        newPanel.present { urls in
            isPresented = false
            panel = nil
            if let urls {
                completion(urls)
            } else {
                // user cancelled or something else happened
            }
        }
    }
    
    private func close() {
        panel?.cancelOperation(nil)
        panel = nil
        isPresented = false
    }
}

extension View {
    public func fileOpenPanel(
        isPresented: Binding<Bool>,
        setup: ((NSOpenPanel) -> Void)? = nil,
        completion: @MainActor @escaping (_ urls: [URL]?) -> Void
    ) -> some View {
        OpenPanelView(
            isPresented: isPresented,
            setup: setup,
            completion: completion,
            content: self
        )
    }
}

#endif
