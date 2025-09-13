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
                        Text("\(subFramesBase.description)").tag(subFramesBase)
                    }
                }
                
                HStack {
                    Text("New Start Timecode")
                    Spacer()
                    
                    TimecodeField(timecode: $newStartTimecode)
                        .timecodeFormat([.showSubFrames])
                        .timecodeSubFramesStyle(.secondary, scale: .secondary)
                        .timecodeFieldValidationPolicy(.enforceValid)
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
        
        #if os(macOS)
        // note that SwiftUI's .fileImporter does not produce a security-scoped URL suitable for writing to on macOS (but seems fine on iOS).
        // also, SwiftUI's .fileExporter insists on writing the data to disk for us with no way to write to the URL manually.
        // hence, our workaround is to use a custom NSOpenPanel wrapper.
        .fileOpenPanel(isPresented: $isFolderPickerShown) { openPanel in
            openPanel.canCreateDirectories = true
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.allowsMultipleSelection = false
            openPanel.title = "Export"
            openPanel.directoryURL = model.defaultFolder
        } completion: { urls in
            guard let url = urls?.first else { return }
            Task { await handleResult(.success(url)) }
        }
        #else
        .fileImporter(
            isPresented: $isFolderPickerShown,
            allowedContentTypes: [.folder]
        ) { result in
            Task { await handleResult(result) }
        }
        .fileDialogDefaultDirectory(model.defaultFolder)
        .fileDialogConfirmationLabel("Export")
        #endif
    }
    
    private func handleResult(_ result: Result<URL, Error>) async {
        do {
            let folderURL = try result.get()
            
            isExportProgressShown = true
            defer { isExportProgressShown = false }
            
            await model.export(
                action: .replaceTimecodeTrack(startTimecode: newStartTimecode),
                toFolder: folderURL,
                revealInFinderOnCompletion: true // only applies to macOS
            )
        } catch {
            model.error = .exportError(error)
        }
    }
}
