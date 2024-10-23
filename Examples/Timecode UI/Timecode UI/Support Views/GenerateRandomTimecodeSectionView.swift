//
//  GenerateRandomTimecodeSectionView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKitCore

struct GenerateRandomTimecodeSectionView: View {
    var onNewTimecode: (_ randomTimecode: Timecode) -> Void
    
    var body: some View {
        Section("Set Timecode") {
            LabeledContent("Random Valid Timecode (HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    var newTimecode = Timecode(.randomComponentsAndProperties)
                    newTimecode.days = 0
                    newTimecode.upperLimit = .max24Hours
                    onNewTimecode(newTimecode)
                }
            }
            LabeledContent("Random Valid Timecode (DD HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    let newTimecode = Timecode(.randomComponentsAndProperties)
                    onNewTimecode(newTimecode)
                }
            }
            LabeledContent("Random Invalid Timecode (HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    var newTimecode = Timecode(
                        .randomComponentsAndProperties(in: .unsafeRandomRanges),
                        by: .allowingInvalid
                    )
                    newTimecode.days = 0
                    newTimecode.upperLimit = .max24Hours
                    onNewTimecode(newTimecode)
                }
            }
            LabeledContent("Random Invalid Timecode (DD HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    let newTimecode = Timecode(
                        .randomComponentsAndProperties(in: .unsafeRandomRanges),
                        by: .allowingInvalid
                    )
                    onNewTimecode(newTimecode)
                }
            }
        }
    }
}
