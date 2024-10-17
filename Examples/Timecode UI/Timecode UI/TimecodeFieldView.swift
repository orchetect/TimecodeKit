//
//  TimecodeFieldView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct TimecodeFieldView: View {
    @State var components: Timecode.Components = .random(in: .unsafeRandomRanges)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var isEnabled: Bool = true
    @State private var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    @State private var defaultStyle: DefaultStyle = .default
    @State private var separatorStyle: SeparatorStyle = .secondary
    @State private var subFramesStyle: SubFramesStyle = .default
    @State private var subFramesScale: TextScale = .default
    @State private var validationStyle: ValidationStyle = .red
    @State private var highlightStyle: HighlightStyle = .default
    @State private var inputStyle: TimecodeField.InputStyle = .continuousWithinComponent
    @State private var inputWrapping: TimecodeField.InputWrapping = .noWrap
    @State private var validationPolicy: TimecodeField.ValidationPolicy = .allowInvalid
    @State private var validationAnimation: Bool = true
    
    @FocusState private var isEditing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            TimecodeField(
                components: $components,
                at: frameRate,
                base: subFramesBase,
                limit: upperLimit
            )
            .foregroundColor(defaultStyle.color)
            .timecodeFormat(timecodeFormat)
            .timecodeSeparatorStyle(separatorStyle.color)
            .timecodeSubFramesStyle(subFramesStyle.color, scale: subFramesScale.scale)
            .timecodeValidationStyle(validationStyle.color)
            .timecodeFieldHighlightStyle(highlightStyle.color)
            .timecodeFieldInputStyle(inputStyle)
            .timecodeFieldInputWrapping(inputWrapping)
            .timecodeFieldValidationPolicy(validationPolicy, animation: validationAnimation)
            .timecodeFieldReturnAction(.focusNextComponent)
            .timecodeFieldEscapeAction(.resetComponentFocus())
            .font(.largeTitle)
            .disabled(!isEnabled)
            .focused($isEditing)
            
            Divider()
            
            Form {
                propertiesSection
                appearanceSection
                inputBehaviorSection
                infoSection
            }
            .formStyle(.grouped)
        }
        .padding()
        
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .confirmationAction) {
                if isEditing {
                    Button("Done") { isEditing = false }
                }
            }
        }
        #endif
    }
    
    private var propertiesSection: some View {
        Section("Timecode Properties") {
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
    
    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Default Color", selection: $defaultStyle) {
                ForEach(DefaultStyle.allCases) { defaultType in
                    Text(defaultType.name).tag(defaultType)
                }
            }
            Picker("Highlight Color", selection: $highlightStyle) {
                ForEach(HighlightStyle.allCases) { color in
                    Text(color.name).tag(color)
                }
            }
            Picker("Separator Color", selection: $separatorStyle) {
                ForEach(SeparatorStyle.allCases) { color in
                    Text(color.name).tag(color)
                }
            }
            Picker("Validation Style", selection: $validationStyle) {
                ForEach(ValidationStyle.allCases) { validationType in
                    Text(validationType.name).tag(validationType)
                }
            }
            Picker("SubFrames Color", selection: $subFramesStyle) {
                ForEach(SubFramesStyle.allCases) { style in
                    Text(style.name).tag(style)
                }
            }
            Picker("SubFrames Scale", selection: $subFramesScale) {
                ForEach(TextScale.allCases) { scale in
                    Text(scale.name).tag(scale)
                }
            }
        }
    }
    
    private var inputBehaviorSection: some View {
        Section("Input Behavior") {
            Picker("Input Style", selection: $inputStyle) {
                ForEach(TimecodeField.InputStyle.allCases) { style in
                    Text(style.name).tag(style)
                }
            }
            Picker("Input Wrapping", selection: $inputWrapping) {
                ForEach(TimecodeField.InputWrapping.allCases) { wrapping in
                    Text(wrapping.name).tag(wrapping)
                }
            }
            Picker("Validation Policy", selection: $validationPolicy) {
                ForEach(TimecodeField.ValidationPolicy.allCases) { policy in
                    Text(policy.name).tag(policy)
                }
            }
            Toggle(isOn: $validationAnimation) {
                Text("Validation Feedback Animation")
            }
            .disabled(validationPolicy != .enforceValid)
            Toggle(isOn: $timecodeFormat.option(.showSubFrames)) {
                Text("Show SubFrames")
            }
            Toggle(isOn: $isEnabled) {
                Text("Enabled")
            }
        }
    }
    
    private var infoSection: some View {
        Section("Hardware Keyboard Guide") {
            Grid(alignment: .topLeading, verticalSpacing: 10) {
                GridRow {
                    HStack {
                        Image(systemName: "arrow.left")
                        Image(systemName: "arrow.right")
                    }
                    Text("Left and right arrow keys can be used to cycle through timecode components while editing.")
                }
                GridRow {
                    HStack {
                        Image(systemName: "arrow.up")
                        Image(systemName: "arrow.down")
                    }
                    Text("Up and down arrow keys can be used to increment or decrement the highlighted timecode components.")
                }
                GridRow {
                    HStack {
                        Image(systemName: "plus")
                        Image(systemName: "minus")
                    }
                    Text("Plus and minus keys (on the number row or number pad) can be used to increment or decrement the highlighted timecode components.")
                }
                GridRow {
                    Text("`.` or `:` or `;`")
                    Text("Entering a timecode separator character will advance the highlight to the next timecode component.")
                }
                GridRow {
                    Image(systemName: "number.square")
                    Text("Number keys can be used to overwrite the currently highlighted timecode component.")
                }
            }
        }
    }
    
    private var timecode: Timecode {
        Timecode(
            .components(components),
            at: frameRate,
            base: subFramesBase,
            limit: upperLimit,
            by: .allowingInvalid
        )
    }
}

// MARK: - View Property Types

extension TimecodeFieldView {
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
    
    private enum HighlightStyle: Int, CaseIterable, Identifiable {
        case `default`
        case secondary
        case blue
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: "Default (Accent)"
            case .secondary: "Secondary"
            case .blue: "Blue"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: .accentColor
            case .secondary: .secondary
            case .blue: .blue
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

extension TimecodeField.InputStyle {
    var name: String {
        switch self {
        case .autoAdvance: "Auto-Advance"
        case .continuousWithinComponent: "Continuous"
        case .unbounded: "Unbounded"
        }
    }
}

extension TimecodeField.InputWrapping {
    var name: String {
        switch self {
        case .noWrap: "No Wrap"
        case .wrap: "Wrap"
        }
    }
}

extension TimecodeField.ValidationPolicy {
    var name: String {
        switch self {
        case .allowInvalid: "Allow Invalid"
        case .enforceValid: "Enforce Valid"
        }
    }
}

#Preview {
    TimecodeFieldView()
        .frame(minHeight: 700)
}
