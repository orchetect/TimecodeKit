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
                    onNewTimecode(randomValid(limit: .max24Hours))
                }
            }
            LabeledContent("Random Valid Timecode (DD HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    onNewTimecode(randomValid(limit: .max100Days))
                }
            }
            LabeledContent("Random Invalid Timecode (HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    onNewTimecode(randomInvalid(limit: .max24Hours))
                }
            }
            LabeledContent("Random Invalid Timecode (DD HH:MM:SS:FF.SF)") {
                Button("Randomize") {
                    onNewTimecode(randomInvalid(limit: .max100Days))
                }
            }
        }
    }
    
    private func randomValid(limit: Timecode.UpperLimit) -> Timecode {
        var newTimecode: Timecode
        repeat {
            newTimecode = Timecode(.randomComponentsAndProperties)
        } while newTimecode.upperLimit != limit
        
        return newTimecode
    }
    
    private func randomInvalid(limit: Timecode.UpperLimit) -> Timecode {
        var newTimecode: Timecode
        repeat {
            newTimecode = Timecode(
                .randomComponentsAndProperties(in: .unsafeRandomRanges),
                by: .allowingInvalid
            )
        } while newTimecode.upperLimit != limit
        return newTimecode
    }
}
