//
//  TimecodeFieldView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct TimecodeFieldView: View {
    @State var components = Timecode.Components(d: 01, h: 02, m: 10, s: 20, f: 29, sf: 82)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var isEnabled: Bool = true
    @State private var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    @State private var validationStyle: ValidationStyle = .red
    @State private var separatorStyle: SeparatorStyle = .secondary
    @State private var highlightStyle: HighlightStyle = .default
    
    var body: some View {
        VStack(spacing: 20) {
            TimecodeField(
                components: $components,
                at: frameRate,
                base: subFramesBase,
                limit: upperLimit
            )
            .timecodeFormat(timecodeFormat)
            .timecodeValidationStyle(validationStyle.color)
            .timecodeSeparatorStyle(separatorStyle.color)
            .timecodeHighlightStyle(highlightStyle.color)
            .font(.largeTitle)
            .disabled(!isEnabled)
            
            Divider()
            
            Form {
                propertiesSection
                settingsSection
                infoSection
            }
            .formStyle(.grouped)
        }
        .padding()
//        .frame(idealHeight: 700)
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
            Picker("Component Validation", selection: $validationStyle) {
                ForEach(ValidationStyle.allCases) { validationType in
                    Text(validationType.name).tag(validationType)
                }
            }
            Picker("Separator Color", selection: $separatorStyle) {
                ForEach(SeparatorStyle.allCases) { color in
                    Text(color.name).tag(color)
                }
            }
            Picker("Highlight Color", selection: $highlightStyle) {
                ForEach(HighlightStyle.allCases) { color in
                    Text(color.name).tag(color)
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
    
    private var infoSection: some View {
        Section("Info") {
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

extension TimecodeFieldView {
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
    
    private enum HighlightStyle: Int, CaseIterable, Identifiable {
        case `default`
        case secondary
        case blue
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .default: return "Default (Accent Color)"
            case .secondary: return "Secondary"
            case .blue: return "Blue"
            }
        }
        
        var color: Color? {
            switch self {
            case .default: return nil
            case .secondary: return .secondary
            case .blue: return .blue
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
    TimecodeFieldView()
        .frame(minHeight: 700)
}
