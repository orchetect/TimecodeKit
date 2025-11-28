//
//  Utilities.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension Image {
    func sizeForOperation() -> some View {
        resizable()
            .frame(width: 30, height: 30)
    }
}
