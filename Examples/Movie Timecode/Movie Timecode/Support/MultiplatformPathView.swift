//
//  MultiplatformPathView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct MultiplatformPathView: View {
    var url: URL?
    @Binding var isFileImporterShown: Bool

    var body: some View {
        HStack {
            if let url {
                #if os(macOS)
                Spacer()
                    .layoutPriority(0)
                PathView(url: url, style: .popUp)
                    .layoutPriority(-1)
                #else
                Text(url.lastPathComponent)
                #endif
            }
            
            Button("...") {
                isFileImporterShown = true
            }
            .fixedSize()
        }
    }
}
