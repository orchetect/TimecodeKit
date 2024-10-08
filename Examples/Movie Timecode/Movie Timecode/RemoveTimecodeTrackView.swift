//
//  RemoveTimecodeTrackView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import Observation

struct RemoveTimecodeTrackView: View {
    @Environment(Model.self) private var model
    
    @Binding var isExportProgressShown: Bool
    
    @State private var isFolderPickerShown: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Text("Removes the timecode track from the video if one is present.")
                Text("A copy of the video will be exported and the original file will remain unmodified.")
                
                LabeledContent("") {
                    Button("Export") {
                        isFolderPickerShown = true
                    }
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
        case .success(let folderURL):
            isExportProgressShown = true
            guard let fileURL = model.uniqueExportURL(folder: folderURL) else { return }
            print("Exporting to \(fileURL.path)")
            
            await model.exportRemovingTimecodeTrack(
                to: fileURL,
                revealInFinderOnCompletion: true
            )
            isExportProgressShown = false
        case .failure(let error):
            model.error = ModelError.exportError(error)
        }
    }
}
