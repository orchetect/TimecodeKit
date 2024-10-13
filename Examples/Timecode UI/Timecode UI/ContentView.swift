//
//  ContentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct ContentView: View {
    @State private var sideBarItem: SideBarItem?
    
    var body: some View {
        NavigationSplitView {
            List(SideBarItem.allCases, selection: $sideBarItem) { item in
                item.label.tag(item)
            }
            .frame(minWidth: 180)
        } detail: {
            switch sideBarItem {
            case .timecodeField: TimecodeFieldView()
            case .timecodeText: TimecodeTextDemoView()
            case nil: Text("Select a sidebar entry.")
            }
        }
        .onAppear {
            #if os(macOS)
            sideBarItem = .timecodeField
            #endif
        }
    }
    
    enum SideBarItem: Int, CaseIterable, Identifiable {
        case timecodeField
        case timecodeText
        
        var id: RawValue { rawValue }
        
        var label: some View {
            switch self {
            case .timecodeField:
                Label("TimecodeField", systemImage: "numbers.rectangle")
            case .timecodeText:
                Label("TimecodeText", systemImage: "numbers")
            }
        }
    }
}

#Preview {
    ContentView()
}
