//
//  Utilities.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension Image {
    func sizeForOperation() -> some View {
        resizable()
            .frame(width: 30, height: 30)
    }
}
