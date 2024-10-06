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
        case .addOrReplaceTimecodeTrack: return "Add or Replace"
        case .removeTimecodeTrack: return "Remove"
        }
    }
    
    var systemImage: String {
        switch self {
        case .addOrReplaceTimecodeTrack:
            return "video.fill.badge.plus"
        case .removeTimecodeTrack:
            return "video.slash.fill"
        }
    }
}
