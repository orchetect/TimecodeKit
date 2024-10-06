//
//  ContentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct ContentView: View {
    @State private var sideBarItem: SideBarItem = .timecodeField
    
    var body: some View {
        NavigationSplitView {
            List(SideBarItem.allCases, selection: $sideBarItem) { item in
                Text(item.name).tag(item)
            }
        } detail: {
            switch sideBarItem {
            case .timecodeField: TimecodeFieldView()
            case .timecodeText: TimecodeTextView()
            }
        }

    }
    
    enum SideBarItem: Int, CaseIterable, Identifiable {
        case timecodeField
        case timecodeText
        
        var id: RawValue { rawValue }
        
        var name: String {
            switch self {
            case .timecodeField: return "Editable Field"
            case .timecodeText: return "Text"
            }
        }
    }
}

struct TimecodeFieldView: View {
    @State var components = Timecode.Components(d: 01, h: 02, m: 10, s: 20, f: 29, sf: 82)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var isEnabled: Bool = true
    @State private var validationType: ValidationType = .red
    @State private var separatorColor: SeparatorColor = .secondary
    
    var body: some View {
        VStack(spacing: 20) {
            TimecodeField(
                components: $components,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                showSubFrames: true
            )
            .timecodeFieldValidationStyle(validationType.color)
            .timecodeFieldSeparatorStyle(separatorColor.color)
            .font(.largeTitle)
            .disabled(!isEnabled)
            
            Divider()
            
            Form {
                Picker("Frame Rate", selection: $frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { frameRate in
                        Text(frameRate.stringValueVerbose).tag(frameRate)
                    }
                }
                Picker("SubFrames Base", selection: $subFramesBase) {
                    ForEach(Timecode.SubFramesBase.allCases) { subFramesBase in
                        Text("\(subFramesBase)").tag(subFramesBase)
                    }
                }
                Picker("Upper Limit", selection: $upperLimit) {
                    ForEach(Timecode.UpperLimit.allCases) { upperLimit in
                        Text(upperLimit.rawValue).tag(upperLimit)
                    }
                }
                Picker("Component Validation", selection: $validationType) {
                    ForEach(ValidationType.allCases) { validationType in
                        Text(validationType.name).tag(validationType)
                    }
                }
                Picker("Separator Color", selection: $separatorColor) {
                    ForEach(SeparatorColor.allCases) { color in
                        Text(color.name).tag(color)
                    }
                }
                Toggle(isOn: $isEnabled) {
                    Text("Enabled")
                }
                
                Section("Info") {
                    List {
                        Text("Left and right arrow keys can be used to cycle through timecode components while editing.")
                        Text("Entering a separator character (`.` or `:` or `;`) will advance the highlight to the next timecode component.")
                        Text("Up and down arrow keys can be used to increment or decrement the highlighted timecode components.")
                        Text("Number keys can be used to overwrite the currently highlighted timecode component.")
                        Text("The optional `timecodeFieldValidationStyle` modifier causes invalid timecode components to render with a different foreground color (red in this example).")
                        Text("When applying the `disabled()` modifier, the field becomes read-only and not selectable or editable.")
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .frame(idealHeight: 800)
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
    
    private enum SeparatorColor: Int, CaseIterable, Identifiable {
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
    
    private enum ValidationType: Int, CaseIterable, Identifiable {
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

struct TimecodeTextView: View {
    @State var components = Timecode.Components(d: 01, h: 02, m: 10, s: 20, f: 29, sf: 82)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var validationType: ValidationType = .red
    @State private var defaultType: DefaultType = .default
    
    var body: some View {
        VStack(spacing: 20) {
            Text(
                timecode: timecode,
                format: [.showSubFrames],
                invalidModifiers: validationType.modifiers,
                defaultModifiers: defaultType.modifiers
            )
            .font(.largeTitle)
            
            Divider()
            
            Form {
                Picker("Frame Rate", selection: $frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { frameRate in
                        Text(frameRate.stringValueVerbose).tag(frameRate)
                    }
                }
                Picker("SubFrames Base", selection: $subFramesBase) {
                    ForEach(Timecode.SubFramesBase.allCases) { subFramesBase in
                        Text("\(subFramesBase)").tag(subFramesBase)
                    }
                }
                Picker("Upper Limit", selection: $upperLimit) {
                    ForEach(Timecode.UpperLimit.allCases) { upperLimit in
                        Text(upperLimit.rawValue).tag(upperLimit)
                    }
                }
                Picker("Component Validation", selection: $validationType) {
                    ForEach(ValidationType.allCases) { validationType in
                        Text(validationType.name).tag(validationType)
                    }
                }
                Picker("Default Color", selection: $defaultType) {
                    ForEach(DefaultType.allCases) { defaultType in
                        Text(defaultType.name).tag(defaultType)
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
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
    
    private enum DefaultType: Int, CaseIterable, Identifiable {
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
        
        var modifiers: ((Text) -> Text)? {
            switch self {
            case .default: return nil
            case .blue: return { $0.foregroundStyle(.blue) }
            case .orange: return { $0.foregroundStyle(.orange) }
            }
        }
    }
    
    private enum ValidationType: Int, CaseIterable, Identifiable {
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
        
        var modifiers: ((Text) -> Text)? {
            switch self {
            case .none: return { $0 }
            case .red: return { $0.foregroundStyle(.red) }
            case .purple: return { $0.foregroundStyle(.purple) }
            }
        }
    }
}

#Preview {
    ContentView()
}
