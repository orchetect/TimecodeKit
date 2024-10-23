//
//  TimecodePropertiesSectionView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKitCore

struct TimecodePropertiesSectionView: View {
    @Binding var frameRate: TimecodeFrameRate
    @Binding var subFramesBase: Timecode.SubFramesBase
    @Binding var upperLimit: Timecode.UpperLimit
    
    var body: some View {
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
}
