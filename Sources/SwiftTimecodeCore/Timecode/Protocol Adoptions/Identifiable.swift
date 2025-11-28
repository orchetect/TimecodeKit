//
//  Identifiable.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode: Identifiable {
    public var id: Self { self }
}
