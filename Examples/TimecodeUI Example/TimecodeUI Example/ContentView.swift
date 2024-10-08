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
                Text(item.name).tag(item)
            }
        } detail: {
            switch sideBarItem {
            case .timecodeField: TimecodeFieldView()
            case .timecodeText: TimecodeTextView()
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
        
        var name: String {
            switch self {
            case .timecodeField: return "Editable Field"
            case .timecodeText: return "Text"
            }
        }
    }
}

#Preview {
    ContentView()
}
