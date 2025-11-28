//
//  StringFormat Bindings.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import SwiftTimecodeCore

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding where Value == Timecode.StringFormat {
    /// Returns a SwiftUI `Bool` `Binding` that gets and sets the the specified option in
    /// `Timecode.StringFormat`.
    ///
    /// If the option is present, `true` is returned.
    /// Setting `true` inserts the option, and setting `false` removes the option.
    ///
    /// Usage:
    ///
    /// ```swift
    /// @State private var timecodeFormat: Timecode.StringFormat = []
    ///
    /// var body: some View {
    ///     Toggle(
    ///         "Show SubFrames",
    ///         isOn: $timecodeFormat.option(.showSubFrames)
    ///     )
    /// }
    /// ```
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
