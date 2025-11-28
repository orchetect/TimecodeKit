//
//  RemoveTimecodeTrackView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Observation
import SwiftUI

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
                    .keyboardShortcut(.defaultAction)
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
                action: .removeTimecodeTrack,
                toFolder: folderURL,
                revealInFinderOnCompletion: true // only applies to macOS
            )
        } catch {
            model.error = .exportError(error)
        }
    }
}
