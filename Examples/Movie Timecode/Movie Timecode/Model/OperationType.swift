//
//  OperationType.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

enum OperationType: Int, Identifiable, CaseIterable {
    case addOrReplaceTimecodeTrack
    case removeTimecodeTrack
    
    var id: RawValue { rawValue }
    
    var title: String {
        switch self {
        case .addOrReplaceTimecodeTrack: "Add or Replace"
        case .removeTimecodeTrack: "Remove"
        }
    }
    
    var systemImage: String {
        switch self {
        case .addOrReplaceTimecodeTrack:
            "video.fill.badge.plus"
        case .removeTimecodeTrack:
            "video.slash.fill"
        }
    }
}
