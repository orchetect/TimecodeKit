//
//  AttributedString Previews.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import Foundation
import SwiftUI
import TimecodeKitCore

// TODO: Find a way to conditionally build Previews
// `#if DEBUG` isn't good enough because it's causing docc generation to fail.
// `#if ENABLE_PREVIEWS` no longer works in Xcode 16 either.
#if false // set to true to enable previews

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview {
    @Previewable @TimecodeState var timecode: Timecode = .init(
        .randomComponentsAndProperties(in: .unsafeRandomRanges),
        by: .allowingInvalid
    )
    @Previewable @State var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    
    let attributedStringDefault = AttributedString(
        timecode
    )
    let attributedStringCustom = AttributedString(
        timecode,
        format: timecodeFormat,
        separatorStyle: .secondary,
        validationStyle: .purple
    )
    
    VStack {
        Group {
            Text(attributedStringDefault)
            Text(attributedStringCustom)
            Text(attributedStringCustom)
                .foregroundColor(.blue)
        }
        .font(.largeTitle)
        
        Button("Refresh") {
            timecode = .init(
                .randomComponentsAndProperties(in: .unsafeRandomRanges),
                by: .allowingInvalid
            )
        }
        
        Toggle("Show SubFrames", isOn: $timecodeFormat.option(.showSubFrames))
    }
    .padding()
    .frame(minWidth: 400)
}

#endif

#endif
