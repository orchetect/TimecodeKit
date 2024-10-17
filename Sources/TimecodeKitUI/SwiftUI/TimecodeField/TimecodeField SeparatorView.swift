//
//  TimecodeField SeparatorView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// Timecode separator view.
    struct SeparatorView: View {
        // MARK: - Properties settable through view initializers
        
        let text: String
        
        // MARK: - Properties settable through custom view modifiers
        
        @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle: Color?
        
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
