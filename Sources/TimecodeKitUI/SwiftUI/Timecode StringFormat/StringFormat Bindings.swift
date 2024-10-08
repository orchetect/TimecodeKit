//
//  StringFormat Bindings.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)
import SwiftUI
import TimecodeKit

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding where Value == Timecode.StringFormat {
    /// Returns a `Bool` binding that gets and sets the presence of the given option.
    ///
    /// If the option is present, `true` is returned.
    /// Setting `true` inserts the option, and setting `false` removes the option.
    public func option(_ option: Timecode.StringFormatOption) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                wrappedValue.contains(option)
            },
            set: {
                if $0 { wrappedValue.insert(option) }
                else { wrappedValue.remove(option) }
            }
        )
    }
}

#endif
