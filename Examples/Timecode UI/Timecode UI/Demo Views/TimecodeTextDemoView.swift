//
//  TimecodeTextDemoView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct TimecodeTextDemoView: View {
    var body: some View {
        #if os(macOS)
        // show two views to allow drag & drop of timecode between the two
        VStack {
            HStack {
                TimecodeTextView()
                TimecodeTextView()
            }
            
            info
                .padding([.bottom])
        }
        #else
        TimecodeTextView()
        #endif
    }
    
    private var info: some View {
        Form {
            Section("Info") {
                Grid(alignment: .topLeading, verticalSpacing: 10) {
                    GridRow {
                        Image(systemName: "lightbulb.fill")
                        Text("Try drag & drop between the timecode text instances.")
                            .gridColumnAlignment(.leading)
                    }
                    GridRow {
                        Image(systemName: "lightbulb.fill")
                        Text("Try selecting one timecode by clicking on it and copy it (⌘C) then select the other timecode and paste (⌘P).")
                    }
                    GridRow {
                        Image(systemName: "lightbulb.fill")
                        Text("The timecode can also be copied and pasted into other applications as a plain-text string.")
                    }
                    GridRow {
                        Image(systemName: "lightbulb.fill")
                        Text("Note that to allow drag & drop or copy & paste, your app must export Timecode's UT Type by adding it to the Info.plist. See TimecodeKit documentation for more details.")
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(height: 220)
    }
}

struct TimecodeTextView: View {
    @State var components: Timecode.Components = .random(in: .unsafeRandomRanges)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var isEnabled: Bool = true
    @State private var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    @State private var defaultStyle: DefaultStyle = .default
    @State private var separatorStyle: SeparatorStyle = .secondary
    @State private var validationStyle: ValidationStyle = .red
    @State private var subFramesStyle: SubFramesStyle = .default
    @State private var subFramesScale: TextScale = .default
    
    var body: some View {
        VStack(spacing: 20) {
            TimecodeText(timecode)
                .foregroundColor(defaultStyle.color)
                .timecodeFormat(timecodeFormat)
                .timecodeSeparatorStyle(separatorStyle.color)
                .timecodeSubFramesStyle(subFramesStyle.color, scale: subFramesScale.scale)
                .timecodeValidationStyle(validationStyle.color)
                .font(.largeTitle)
                .disabled(!isEnabled)
                .focusable(isEnabled) // allows selection for Cmd+C (copy) / Cmd+P (paste)
                
                #if os(macOS)
                .copyable([timecode])
                .pasteDestination(for: Timecode.self) { items in
                    // note that this allows pasting timecode with different properties
                    // (frame rate, subframes base, upper limit)
                    // if decoding from rich data (when pasting an encoded `Timecode` struct)
                    guard let item = items.first else { return }
                    timecode = item
                }
                #endif
                
                .draggable(timecode)
                .dropDestination(for: Timecode.self) { items, location in
                    guard let item = items.first else { return false }
                    timecode = item
                    return true
                }
            
            Divider()
            
            Form {
                propertiesSection
                settingsSection
                timecodeSection
            }
            .formStyle(.grouped)
        }
        .padding()
    }
    
    private var propertiesSection: some View {
        TimecodePropertiesSectionView(
            frameRate: $frameRate,
            subFramesBase: $subFramesBase,
            upperLimit: $upperLimit
        )
    }
    
    private var settingsSection: some View {
        Section("Settings") {
            Picker("Default Color", selection: $defaultStyle) {
                ForEach(DefaultStyle.allCases) { defaultType in
                    Text(defaultType.name).tag(defaultType)
                }
            }
            Picker("Separator Color", selection: $separatorStyle) {
                ForEach(SeparatorStyle.allCases) { color in
                    Text(color.name).tag(color)
                }
            }
            Picker("Validation Color", selection: $validationStyle) {
                ForEach(ValidationStyle.allCases) { validationType in
                    Text(validationType.name).tag(validationType)
                }
            }
            Picker("SubFrames Color", selection: $subFramesStyle) {
                ForEach(SubFramesStyle.allCases) { style in
                    Text(style.name).tag(style)
                }
            }
            Picker("SubFrames Text Scale", selection: $subFramesScale) {
                ForEach(TextScale.allCases) { scale in
                    Text(scale.name).tag(scale)
                }
            }
            Toggle(isOn: $timecodeFormat.option(.showSubFrames)) {
                Text("Show SubFrames")
            }
            Toggle(isOn: $timecodeFormat.option(.alwaysShowDays)) {
                Text("Always Show Days")
            }
            Toggle(isOn: $isEnabled) {
                Text("Enabled")
            }
        }
    }
    
    private var timecodeSection: some View {
        GenerateRandomTimecodeSectionView { randomTimecode in
            timecode = randomTimecode
        }
    }
    
    // MARK: - Proxies
    
    private var timecode: Timecode {
        get {
            Timecode(
                .components(components),
                at: frameRate,
                base: subFramesBase,
                limit: upperLimit,
                by: .allowingInvalid
            )
        }
        nonmutating set {
            components = newValue.components
            timecodeProperties = newValue.properties
        }
    }
    
    private var timecodeProperties: Timecode.Properties {
        get {
            Timecode.Properties(
                rate: frameRate,
                base: subFramesBase,
                limit: upperLimit
            )
        }
        nonmutating set {
            frameRate = newValue.frameRate
            subFramesBase = newValue.subFramesBase
            upperLimit = newValue.upperLimit
        }
    }
}

// MARK: - View Property Types

extension TimecodeTextView {
    private enum DefaultStyle: Int, CaseIterable, Identifiable {
        case `default`
        case blue
        case orange
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: "Default"
            case .blue: "Blue"
            case .orange: "Orange"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: nil
            case .blue: .blue
            case .orange: .orange
            }
        }
    }
    
    private enum SubFramesStyle: Int, CaseIterable, Identifiable {
        case `default`
        case primary
        case secondary
        case blue
        case orange
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: "Default"
            case .primary: "Primary"
            case .secondary: "Secondary"
            case .blue: "Blue"
            case .orange: "Orange"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: nil
            case .primary: .primary
            case .secondary: .secondary
            case .blue: .blue
            case .orange: .orange
            }
        }
    }
    
    private enum TextScale: String, CaseIterable, Identifiable {
        case `default`
        case secondary
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: "Default"
            case .secondary: "Secondary"
            }
        }
        
        var scale: Text.Scale {
            switch self {
            case .default: .default
            case .secondary: .secondary
            }
        }
    }
    
    private enum SeparatorStyle: Int, CaseIterable, Identifiable {
        case `default`
        case primary
        case secondary
        case blue
        case orange
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: "Default"
            case .primary: "Primary"
            case .secondary: "Secondary"
            case .blue: "Blue"
            case .orange: "Orange"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: nil
            case .primary: .primary
            case .secondary: .secondary
            case .blue: .blue
            case .orange: .orange
            }
        }
    }
    
    private enum ValidationStyle: Int, CaseIterable, Identifiable {
        case none
        case red
        case purple
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .none: "None"
            case .red: "Red"
            case .purple: "Purple"
            }
        }
        
        var color: Color? {
            switch self {
            case .none: nil
            case .red: .red
            case .purple: .purple
            }
        }
    }
}

#Preview {
    TimecodeTextDemoView()
}
