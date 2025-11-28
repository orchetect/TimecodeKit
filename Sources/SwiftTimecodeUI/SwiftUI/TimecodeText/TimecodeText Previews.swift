//
//  TimecodeText Previews.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

// TODO: Find a way to conditionally build Previews
// `#if DEBUG` isn't good enough because it's causing docc generation to fail.
// `#if ENABLE_PREVIEWS` no longer works in Xcode 16 either.
#if false // set to true to enable previews

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
    @Previewable @TimecodeState var timecode = Timecode(
        .components(d: 02, h: 04, m: 20, s: 30, f: 25, sf: 82),
        using: Timecode.Properties(
            rate: .fps24,
            base: .max100SubFrames,
            limit: .max100Days
        ),
        by: .allowingInvalid
    )
    @Previewable @State var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    
    VStack {
        VStack {
            Text("\(timecode)") // no modifiers are applied, just here to test
            TimecodeText(timecode)
            TimecodeText(timecode)
                .foregroundColor(.blue)
                .timecodeSubFramesStyle(.secondary, scale: .secondary)
        }
        .font(.largeTitle)
        .timecodeFormat(timecodeFormat)
        .timecodeSeparatorStyle(.secondary)
        .timecodeValidationStyle(.red)
        
        Form {
            LabeledContent("Frame Rate") {
                Button("24") { timecode.frameRate = .fps24 }
                Button("30") { timecode.frameRate = .fps30 }
            }
            LabeledContent("SubFrames Base") {
                Button("80") { timecode.subFramesBase = .max80SubFrames }
                Button("100") { timecode.subFramesBase = .max100SubFrames }
            }
            LabeledContent("Upper Limit") {
                Button("24 Hours") { timecode.upperLimit = .max24Hours }
                Button("100 Days") { timecode.upperLimit = .max100Days }
            }
            LabeledContent("Randomize Invalid Components") {
                Button("Randomize") {
                    timecode = .init(
                        .randomComponentsAndProperties(in: .unsafeRandomRanges),
                        by: .allowingInvalid
                    )
                }
            }
            Toggle("Show SubFrames", isOn: $timecodeFormat.option(.showSubFrames))
        }
        .formStyle(.grouped)
    }
    .padding()
    .frame(minWidth: 400)
}

#endif

#endif
