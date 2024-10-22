//
//  AddOrReplaceTimecodeTrackView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Observation
import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct AddOrReplaceTimecodeTrackView: View {
    @Environment(Model.self) private var model
    
    @TimecodeState var newStartTimecode: Timecode
    @Binding var isExportProgressShown: Bool
    
    @State private var isFolderPickerShown: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Text("Adds a new timecode track to the video, or replaces the existing timecode track if one is present.")
                Text("A copy of the video will be exported and the original file will remain unmodified.")
                
                Picker("Frame Rate", selection: $newStartTimecode.frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { frameRate in
                        Text(frameRate.stringValueVerbose).tag(frameRate)
                    }
                }
                Picker("SubFrames Base", selection: $newStartTimecode.subFramesBase) {
                    ForEach(Timecode.SubFramesBase.allCases) { subFramesBase in
                        Text("\(subFramesBase)").tag(subFramesBase)
                    }
                }
                
                HStack {
                    Text("New Start Timecode")
                    Spacer()
                    
                    TimecodeField(timecode: $newStartTimecode)
                        .timecodeFormat([.showSubFrames])
                        .timecodeSubFramesStyle(.secondary, scale: .secondary)
                        .timecodeFieldValidationPolicy(.enforceValid)
                        .timecodeFieldInputRejectionFeedback(.validationBased(animation: true))
                }
                
                LabeledContent("") {
                    Button("Export") {
                        isFolderPickerShown = true
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(!newStartTimecode.isValid)
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .fileImporter(
            isPresented: $isFolderPickerShown,
            allowedContentTypes: [.folder]
        ) { result in
            Task { await handleResult(result) }
        }
        .fileDialogDefaultDirectory(model.defaultFolder)
        .fileDialogConfirmationLabel("Export")
    }
    
    private func handleResult(_ result: Result<URL, Error>) async {
        switch result {
        case let .success(folderURL):
            isExportProgressShown = true
            guard let fileURL = model.uniqueExportURL(folder: folderURL) else { return }
            print("Exporting to \(fileURL.path)")
            
            await model.exportReplacingTimecodeTrack(
                startTimecode: newStartTimecode,
                to: fileURL,
                revealInFinderOnCompletion: true
            )
            isExportProgressShown = false
        case let .failure(error):
            model.error = ModelError.exportError(error)
        }
    }
}
