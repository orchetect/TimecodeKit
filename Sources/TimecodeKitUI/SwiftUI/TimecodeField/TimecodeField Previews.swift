//
//  TimecodeField Previews.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

// TODO: Find a way to conditionally build Previews
// `#if DEBUG` isn't good enough because it's causing docc generation to fail.
// `#if ENABLE_PREVIEWS` no longer works in Xcode 16 either.
#if false // set to true to enable previews

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("HH:MM:SS:FF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
            .timecodeFormat([.showSubFrames])
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeFormat([])
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max24Hours)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .disabled(true)
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
            .timecodeSeparatorStyle(.green)
            .timecodeValidationStyle(.red)
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
            .timecodeSeparatorStyle(.green)
            .timecodeValidationStyle(.red)
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .padding()
    .disabled(true)
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview("No Validation") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .timecodeValidationStyle(nil)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview("Timecode Binding") {
    @Previewable @TimecodeState var timecode = Timecode(
        .components(d: 02, h: 04, m: 20, s: 30, f: 25, sf: 82),
        using: Timecode.Properties(
            rate: .fps24,
            base: .max100SubFrames,
            limit: .max100Days
        ),
        by: .allowingInvalid
    )
    @Previewable @State var tcFormat: Timecode.StringFormat = [.showSubFrames]
    
    VStack(alignment: .trailing) {
        Group {
            TimecodeField(timecode: $timecode)
            TimecodeField(
                components: $timecode.components,
                at: timecode.frameRate,
                base: timecode.subFramesBase,
                limit: timecode.upperLimit
            )
            TimecodeText(timecode)
        }
        .font(.largeTitle)
        .timecodeFormat(tcFormat)
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
            LabeledContent("Components") {
                Button("Randomize") { timecode.components = .random(in: .unsafeRandomRanges) }
            }
            Toggle("Show SubFrames", isOn: $tcFormat.option(.showSubFrames))
        }
        .formStyle(.grouped)
    }
    .padding()
    .frame(width: 400)
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("SubFrames Scale Factor") {
    @Previewable @TimecodeState var timecode = Timecode(
        .components(d: 02, h: 04, m: 20, s: 30, f: 20, sf: 82),
        using: Timecode.Properties(
            rate: .fps24,
            base: .max100SubFrames,
            limit: .max100Days
        ),
        by: .allowingInvalid
    )
    
    VStack(alignment: .trailing) {
        TimecodeField(timecode: $timecode)
        TimecodeField(timecode: $timecode)
            .timecodeSubFramesStyle(scale: .default)
        TimecodeField(timecode: $timecode)
            .timecodeSubFramesStyle(.secondary, scale: .default)
        TimecodeField(timecode: $timecode)
            .timecodeSubFramesStyle(scale: .secondary)
        TimecodeField(timecode: $timecode)
            .timecodeSubFramesStyle(.secondary, scale: .secondary)
        
        LabeledContent("SubFrames Base") {
            Button("80") { timecode.subFramesBase = .max80SubFrames }
            Button("100") { timecode.subFramesBase = .max100SubFrames }
        }
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
}

#endif

#endif
