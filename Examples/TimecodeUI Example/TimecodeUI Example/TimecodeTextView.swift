//
//  TimecodeTextView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct TimecodeTextView: View {
    @State var components = Timecode.Components(d: 01, h: 02, m: 10, s: 20, f: 29, sf: 82)
    @State var frameRate: TimecodeFrameRate = .fps24
    @State var subFramesBase: Timecode.SubFramesBase = .max80SubFrames
    @State var upperLimit: Timecode.UpperLimit = .max24Hours
    
    @State private var validationStyle: ValidationStyle = .red
    @State private var defaultStyle: DefaultStyle = .default
    
    var body: some View {
        VStack(spacing: 20) {
            Text(
                timecode: timecode,
                format: [.showSubFrames],
                invalidModifiers: validationStyle.modifiers,
                defaultModifiers: defaultStyle.modifiers
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
                Picker("Component Validation", selection: $validationStyle) {
                    ForEach(ValidationStyle.allCases) { validationType in
                        Text(validationType.name).tag(validationType)
                    }
                }
                Picker("Default Color", selection: $defaultStyle) {
                    ForEach(DefaultStyle.allCases) { defaultType in
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
}

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
        
        var modifiers: ((Text) -> Text)? {
            switch self {
            case .default: return nil
            case .blue: return { $0.foregroundStyle(.blue) }
            case .orange: return { $0.foregroundStyle(.orange) }
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
    TimecodeTextView()
}
