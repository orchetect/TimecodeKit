//
//  NSAttributedStringDemoView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct NSAttributedStringDemoView: View {
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
    
    var body: some View {
        VStack(spacing: 20) {
            Text(AttributedString(nsAttributedString))
//                .foregroundColor(defaultStyle.color)
                .font(.largeTitle)
                .disabled(!isEnabled)
            
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
    
    private var nsAttributedString: NSAttributedString {
        let defaultAttributes: [NSAttributedString.Key: Any]? = if let color = defaultStyle.color {
            [.foregroundColor: color]
        } else {
            nil
        }
        
        let separatorAttributes: [NSAttributedString.Key: Any]? = if let color = separatorStyle.color {
            [.foregroundColor: color]
        } else {
            nil
        }
        
        let subFramesAttributes: [NSAttributedString.Key: Any]? = if let color = subFramesStyle.color {
            [.foregroundColor: color]
        } else {
            nil
        }
        
        let invalidAttributes: [NSAttributedString.Key: Any]? = if let color = validationStyle.color {
            [.foregroundColor: color]
        } else {
            nil
        }
        
        return NSAttributedString(
            timecode,
            format: timecodeFormat,
            defaultAttributes: defaultAttributes,
            separatorAttributes: separatorAttributes,
            subFramesAttributes: subFramesAttributes,
            invalidAttributes: invalidAttributes
        )
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

extension NSAttributedStringDemoView {
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
        
        
        #if os(macOS)
        var color: NSColor? {
            if let _color { NSColor(_color) } else { nil }
        }
        #else
        var color: UIColor? {
            if let _color { UIColor(_color) } else { nil }
        }
        #endif
        
        var _color: Color? {
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
        
        #if os(macOS)
        var color: NSColor? {
            if let _color { NSColor(_color) } else { nil }
        }
        #else
        var color: UIColor? {
            if let _color { UIColor(_color) } else { nil }
        }
        #endif
        
        var _color: Color? {
            switch self {
            case .default: nil
            case .primary: .primary
            case .secondary: .secondary
            case .blue: .blue
            case .orange: .orange
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
        
        #if os(macOS)
        var color: NSColor? {
            if let _color { NSColor(_color) } else { nil }
        }
        #else
        var color: UIColor? {
            if let _color { UIColor(_color) } else { nil }
        }
        #endif
        
        var _color: Color? {
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
        
        #if os(macOS)
        var color: NSColor? {
            if let _color { NSColor(_color) } else { nil }
        }
        #else
        var color: UIColor? {
            if let _color { UIColor(_color) } else { nil }
        }
        #endif
        
        var _color: Color? {
            switch self {
            case .none: nil
            case .red: .red
            case .purple: .purple
            }
        }
    }
}

#Preview {
    NSAttributedStringDemoView()
}
