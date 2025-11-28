//
//  ContentView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct ContentView: View {
    @State private var model = Model()
    
    @State private var isFileImporterShown: Bool = false
    @State private var isExportProgressShown: Bool = false
    @State private var operationType: OperationType = .addOrReplaceTimecodeTrack
    
    var body: some View {
        NavigationStack {
            Form {
                sourceSection
                operationsSection
            }
            .formStyle(.grouped)
            .padding()
            .navigationTitle("Movie Timecode")
        }
        .fileImporter(
            isPresented: $isFileImporterShown,
            allowedContentTypes: [.quickTimeMovie, .mpeg4Movie]
        ) { result in
            model.handleFileImport(result: result)
        }
        .sheet(isPresented: $isExportProgressShown) {
            VStack(spacing: 40) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.extraLarge)
                Text("Exporting Movie...")
            }
            .padding(40)
            .presentationSizing(.fitted)
            .interactiveDismissDisabled(true)
        }
        .alert(isPresented: .constant(model.error != nil), error: model.error) {
            Button("OK") {
                model.error = nil
            }
        }
    }
    
    @ViewBuilder
    private var sourceSection: some View {
        Section("Source") {
            LabeledContent("Movie") {
                MultiplatformPathView(url: model.movieURL, isFileImporterShown: $isFileImporterShown)
            }
            
            LabeledContent("Detected Frame Rate") {
                Text(model.movieFrameRateString)
            }
            
            LabeledContent("Contains Timecode Track") {
                Text(model.containsTimecodeTrackString)
            }
            
            LabeledContent("Start Timecode") {
                Text(model.movieStartTimecodeString)
            }
        }
    }
    
    @ViewBuilder
    private var operationsSection: some View {
        Section("Timecode Track Operations") {
            if model.movie != nil {
                TabView(selection: $operationType) {
                    Tab(
                        OperationType.addOrReplaceTimecodeTrack.title,
                        systemImage: OperationType.addOrReplaceTimecodeTrack.systemImage,
                        value: .addOrReplaceTimecodeTrack
                    ) {
                        AddOrReplaceTimecodeTrackView(
                            newStartTimecode: model.movieStartTimecode ?? model.defaultTimecode,
                            isExportProgressShown: $isExportProgressShown
                        )
                    }
                    
                    Tab(
                        OperationType.removeTimecodeTrack.title,
                        systemImage: OperationType.removeTimecodeTrack.systemImage,
                        value: .removeTimecodeTrack
                    ) {
                        RemoveTimecodeTrackView(
                            isExportProgressShown: $isExportProgressShown
                        )
                    }
                }
                .tabViewStyle(.tabBarOnly)
                #if os(macOS)
                .frame(minHeight: 400)
                #else
                .frame(minHeight: 600)
                #endif
                .environment(model)
            } else {
                ZStack {
                    Text("Load a movie using the panel above.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
