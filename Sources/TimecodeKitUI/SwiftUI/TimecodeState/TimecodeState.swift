//
//  TimecodeState.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

/// Custom SwiftUI state wrapper that ensures changes are pushed to views when any Timecode component or property
/// changes.
///
/// The purpose of this is that SwiftUI's native `@State` wrapper is not sufficient. `@State` relies on `Equatable` to
/// diff old and new copies of a value type. However, `Timecode`'s `Equatable` implementation does not take `upperLimit`
/// into account, and depending on component values, `subFramesBase` may not be taken into account either. That is by
/// design, since it makes comparing two `Timecode` instances idiomatic. This will create an issue when we want to
/// change or observe individual `Timecode` properties in SwiftUI. The solution is a custom state wrapper that forces
/// view updates when any `Timecode` property changes.
@available(iOS 13.0, macOS 11, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper public struct TimecodeState: DynamicProperty {
    public typealias Value = Timecode
    
    @ObservedObject private var wrapper: Wrapper
    
    public var wrappedValue: Timecode {
        get { wrapper.timecode }
        nonmutating set { wrapper.timecode = newValue }
    }
    
    public init(wrappedValue: Timecode) {
        _wrapper = ObservedObject(wrappedValue: Wrapper(timecode: wrappedValue))
    }
    
    public init(initialValue value: Timecode) {
        self.init(wrappedValue: value)
    }
    
    public var projectedValue: Binding<Timecode> {
        Binding(
            get: { wrapper.timecode },
            set: { wrapper.timecode = $0 }
        )
    }
    
    // public func update() { }
    
    private class Wrapper: ObservableObject {
        var timecode: Timecode {
            willSet {
                // this is tantamount to a custom Equatable implementation
                guard timecode.components != newValue.components ||
                    timecode.properties != newValue.properties
                else { return }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        
        init(timecode: Timecode) {
            self.timecode = timecode
        }
    }
}

// Suppress the ability to use `@State` with a `Timecode` instance.
@available(*, unavailable, message: "Use @TimecodeState instead of @State.")
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension State where Value == Timecode {
    public init(wrappedValue: Timecode) { fatalError() }
}

#endif
