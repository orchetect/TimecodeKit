//
//  TimecodeState.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

/// Custom SwiftUI state wrapper that ensures changes are pushed to views when any Timecode component or property
/// changes.
///
/// It is required to store `Timecode` instances in a view using this wrapper in place of the typical SwiftUI
/// `@State` wrapper.
///
/// It may then be passed into subviews using normal SwiftUI Bindings.
///
/// ```swift
/// struct ContentView: View {
///     @TimecodeState private var timecode: Timecode = // ...
///
///     var body: some View {
///         TimecodeText(timecode)
///         MySubView(timecode: $timecode)
///     }
/// }
///
/// struct MySubView: View {
///     @Binding var timecode: Timecode
/// }
/// ```
///
/// > Purpose:
/// >
/// > SwiftUI's native `@State` wrapper is not sufficient to contain `Timecode` state. `@State` relies on `Equatable`
/// > to diff old and new copies of a value type.
/// >
/// > However, `Timecode`'s `Equatable` implementation does not take `upperLimit` into account, and depending on
/// > component values, `subFramesBase` may not be taken into account either.
/// >
/// > This is by design, since it makes comparing two `Timecode` instances idiomatic. However, this creates an issue
/// > when we want to observe changes to individual `Timecode` properties in SwiftUI. The solution is a custom state
/// > wrapper that forces view updates when any `Timecode` property changes.
@available(macOS 11, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@MainActor
@propertyWrapper public struct TimecodeState: DynamicProperty, Sendable {
    public typealias Value = Timecode
    
    @StateObject private var wrapper: Wrapper
    
    public var wrappedValue: Timecode {
        get { wrapper.timecode }
        nonmutating set { wrapper.timecode = newValue }
    }
    
    public init(wrappedValue: Timecode) {
        _wrapper = StateObject(wrappedValue: Wrapper(timecode: wrappedValue))
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
    
    @MainActor
    private final class Wrapper: ObservableObject {
        var timecode: Timecode {
            willSet {
                // this is tantamount to a custom Equatable implementation
                guard timecode.components != newValue.components ||
                    timecode.properties != newValue.properties
                else { return }
                
                // DispatchQueue.main.async { [objectWillChange] in
                Task { [objectWillChange] in
                    objectWillChange.send()
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
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension State where Value == Timecode {
    public init(wrappedValue: Timecode) { fatalError() }
}

#endif
