//
//  OperationType.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

enum OperationType: Int, Identifiable, CaseIterable {
    case addOrReplaceTimecodeTrack
    case removeTimecodeTrack
    
    var id: RawValue { rawValue }
    
    var title: String {
        switch self {
        case .addOrReplaceTimecodeTrack:
            "Add or Replace"
        case .removeTimecodeTrack:
            "Remove"
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
