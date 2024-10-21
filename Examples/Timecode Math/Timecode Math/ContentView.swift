//
//  ContentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct ContentView: View {
    @State private var frameRate: TimecodeFrameRate = .fps24
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                Picker("Frame Rate", selection: $frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { rate in
                        Text(rate.stringValueVerbose).id(rate)
                    }
                }
                
                ExpressionsView(frameRate: frameRate).id(frameRate)
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
