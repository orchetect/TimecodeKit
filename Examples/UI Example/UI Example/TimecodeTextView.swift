//
//  TimecodeTextView.swift
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
                        Text("Try drag & drop between the timecode text instances, or select one and copy one then select the other and paste.")
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
    
    var body: some View {
        VStack(spacing: 20) {
            TimecodeText(timecode)
                .foregroundColor(defaultStyle.color)
                .timecodeFormat(timecodeFormat)
                .timecodeSeparatorStyle(separatorStyle.color)
                .timecodeValidationStyle(validationStyle.color)
                .font(.largeTitle)
                .disabled(!isEnabled)
                .focusable(isEnabled) // allows selection for Cmd+C (copy) / Cmd+P (paste)
                
                #if os(macOS)
                .copyable([timecode])
                .pasteDestination(for: Timecode.self) { items in
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
        Section("Properties") {
            Picker("Frame Rate", selection: $frameRate) {
                ForEach(TimecodeFrameRate.allCases) { frameRate in
                    Text(frameRate.stringValueVerbose).tag(frameRate)
                }
            }
            Picker("SubFrames Base", selection: $subFramesBase) {
                ForEach(Timecode.SubFramesBase.allCases) { subFramesBase in
                    Text("\(subFramesBase.stringValueVerbose)").tag(subFramesBase)
                }
            }
            Picker("Upper Limit", selection: $upperLimit) {
                ForEach(Timecode.UpperLimit.allCases) { upperLimit in
                    Text(upperLimit.rawValue).tag(upperLimit)
                }
            }
        }
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
            Picker("Component Validation", selection: $validationStyle) {
                ForEach(ValidationStyle.allCases) { validationType in
                    Text(validationType.name).tag(validationType)
                }
            }
            Toggle(isOn: $timecodeFormat.option(.showSubFrames)) {
                Text("Show SubFrames")
            }
            Toggle(isOn: $isEnabled) {
                Text("Enabled")
            }
        }
    }
    
    private var timecodeSection: some View {
        Section("Timecode") {
            LabeledContent("Random Valid Timecode") {
                Button("Randomize") {
                    timecode = Timecode(.randomComponentsAndProperties)
                }
            }
            LabeledContent("Random Invalid Timecode") {
                Button("Randomize") {
                    timecode = Timecode(
                        .randomComponentsAndProperties(in: .unsafeRandomRanges),
                        by: .allowingInvalid
                    )
                }
            }
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
            case .default: return "Default"
            case .blue: return "Blue"
            case .orange: return "Orange"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: return nil
            case .blue: return .blue
            case .orange: return .orange
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
            case .default: return "Default"
            case .primary: return "Primary"
            case .secondary: return "Secondary"
            case .blue: return "Blue"
            case .orange: return "Orange"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: return nil
            case .primary: return .primary
            case .secondary: return .secondary
            case .blue: return .blue
            case .orange: return .orange
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
            case .none: return "None"
            case .red: return "Red"
            case .purple: return "Purple"
            }
        }
        
        var color: Color? {
            switch self {
            case .none: return nil
            case .red: return .red
            case .purple: return .purple
            }
        }
    }
}

#Preview {
    TimecodeTextView()
}
