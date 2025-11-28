//
//  ContentView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import SwiftTimecode
import SwiftTimecodeUI

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
            case .timecodeField: TimecodeFieldDemoView()
            case .timecodeText: TimecodeTextDemoView()
            case .attributedString: AttributedStringDemoView()
            case .nsAttributedString: NSAttributedStringDemoView()
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
        case attributedString
        case nsAttributedString
        
        var id: RawValue { rawValue }
        
        var label: some View {
            switch self {
            case .timecodeField:
                Label("TimecodeField", systemImage: "numbers.rectangle")
            case .timecodeText:
                Label("TimecodeText", systemImage: "numbers")
            case .attributedString:
                Label("AttributedString", systemImage: "numbers")
            case .nsAttributedString:
                Label("NSAttributedString", systemImage: "numbers")
            }
        }
    }
}

#Preview {
    ContentView()
}
