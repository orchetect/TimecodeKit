//
//  TimecodeField SeparatorView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// Timecode separator view.
    struct SeparatorView: View {
        // MARK: - Properties settable through view initializers
        
        let text: String
        
        // MARK: - Properties settable through custom view modifiers
        
        @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle
        
        // MARK: - Body
        
        var body: some View {
            ZStack {
                Text(text)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
                    .conditionalForegroundStyle(timecodeSeparatorStyle)
            }
        }
    }
}

#endif
