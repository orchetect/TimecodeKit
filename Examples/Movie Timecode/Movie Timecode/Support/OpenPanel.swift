//
//  OpenPanel.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import AppKit

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
        completion: (_ urls: [URL]?) -> Void
    ) {
        var selectedURLs: [URL]?
        
        if runModal() == .OK {
            selectedURLs = urls
        }
        
        completion(selectedURLs)
    }
}

import SwiftUI

public struct OpenPanelView<Content: View>: View {
    @Binding public var isPresented: Bool
    public let setup: ((_ panel: NSOpenPanel) -> Void)?
    public let completion: (_ urls: [URL]?) -> Void
    public let content: Content
    
    @State private var panel: NSOpenPanel?
    
    public var body: some View {
        content
            .onChange(of: isPresented) { oldValue, newValue in
                newValue ? present() : close()
            }
    }
    
    private func present() {
        let newPanel = NSOpenPanel()
        setup?(newPanel)
        panel = newPanel
        
        var selectedURLs: [URL]?
        
        isPresented = true
        if newPanel.runModal() == .OK {
            selectedURLs = newPanel.urls
        }
        
        completion(selectedURLs)
        panel = nil
        isPresented = false
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
        completion: @escaping (_ urls: [URL]?) -> Void
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
