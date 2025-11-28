//
//  TimecodeField Paste Policy Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import SwiftTimecodeUI
import XCTest

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class TimecodeField_Paste_Policy_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    // Permutations:
    // - Note the columns are in order of evaluation by the `validate()` method.
    // - Entries with combined options (&) are considered the same behavior as far as `validate()` is concerned.
    //
    // PastePolicy              ValidationPolicy  InputStyle                               Timecode.Properties    Valid Values?
    // -----------              ----------------  ---------------------                    ---------------------  -------------
    // preserveLocalProperties  enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // allowNewProperties       enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // discardProperties        enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // allowNewProperties       allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // discardProperties        allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  enforceValid      unbounded                                (rate / base / limit)  yes / no
    // allowNewProperties       enforceValid      unbounded                                (rate / base / limit)  yes / no
    // discardProperties        enforceValid      unbounded                                (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  allowInvalid      unbounded                                (rate / base / limit)  yes / no
    // allowNewProperties       allowInvalid      unbounded                                (rate / base / limit)  yes / no
    // discardProperties        allowInvalid      unbounded                                (rate / base / limit)  yes / no
    
    // MARK: - Error Input
    
    func testValidatePasteResult_Error() {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // if we pass in an error, the properties and policies don't matter as it will early return
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .failure(Timecode.ValidationError.invalid),
                localTimecodeProperties: timecode.properties, // could be anything
                pastePolicy: .preserveLocalProperties, // could be anything
                validationPolicy: .enforceValid, // could be anything
                inputStyle: .autoAdvance // could be anything
            ),
            nil
        )
    }
    
    // MARK: - preserveLocalProperties / enforceValid / autoAdvance
    
    func testValidatePasteResult_Preserve_EnforceValid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_Preserve_EnforceValid_AutoAdvance_SameProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_Preserve_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_Preserve_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    // MARK: - allowNewProperties / enforceValid / autoAdvance
    
    func testValidatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_SameProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .allowNewProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 46))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max80SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    func testValidatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .allowNewProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    // MARK: - discardProperties / enforceValid / autoAdvance
    
    func testValidatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_SameProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because enforceValid rejects new values (which were valid at pasted timecode's frame rate) but are no
        // longer valid at the local frame rate
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    // MARK: - preserveLocalProperties / allowInvalid / autoAdvance
    
    func testValidatePasteResult_Preserve_AllowInvalid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            ),
            timecode
        )
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because preserveLocalProperties takes precedence over allowInvalid
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            ),
            nil
        )
    }
    
    // MARK: - allowNewProperties / allowInvalid / autoAdvance
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 30))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 46))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max80SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 50))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max100SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    // MARK: - discardProperties / allowInvalid / autoAdvance
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 30))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() throws {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 46))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        XCTAssertEqual(validated.components, .init(f: 50))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    // MARK: - preserveLocalProperties / enforceValid / unbounded
    
    // Note:
    // No need to extensively test `enforceValid` cases since `unbounded` will never be allowed.
    // Just one test is probably enough to confirm `unbounded` isn't allowing invalid values with `enforceValid`.
    func testValidatePasteResult_Preserve_EnforceValid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .unbounded
            ),
            nil
        )
        
    }
    
    // MARK: - preserveLocalProperties / allowInvalid / unbounded
    
    func testValidatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_ValidValues() throws {
        let timecode = Timecode(.components(f: 12), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 12))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 30))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 234))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_Unbounded_DifferentProperties_ValidValues() {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .unbounded
            ),
            nil
        )
    }
    
    func testValidatePasteResult_Preserve_AllowInvalid_Unbounded_DifferentProperties_InvalidValues() {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because preserveLocalProperties takes precedence over allowInvalid and unbounded
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .unbounded
            ),
            nil
        )
    }
    
    // MARK: - allowNewProperties / allowInvalid / unbounded
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 30))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 234))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_ValidValues() throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 46))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max80SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesWithinDigitBounds() throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 50))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max100SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    func testValidatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesOutsideDigitBounds()throws  {
        let timecode = Timecode(.components(f: 234), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 234))
        XCTAssertEqual(validated.frameRate, .fps48)
        XCTAssertEqual(validated.subFramesBase, .max100SubFrames)
        XCTAssertEqual(validated.upperLimit, .max100Days)
    }
    
    // MARK: - discardProperties / allowInvalid / unbounded
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_ValidValues() throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .zero)
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 30))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 234))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_ValidValues() throws {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 46))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesWithinDigitBounds() throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 50))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
    
    func testValidatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesOutsideDigitBounds() throws {
        let timecode = Timecode(.components(f: 234), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try XCTUnwrap(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        XCTAssertEqual(validated.components, .init(f: 234))
        XCTAssertEqual(validated.frameRate, testFrameRate)
        XCTAssertEqual(validated.subFramesBase, testSubFramesBase)
        XCTAssertEqual(validated.upperLimit, .max24Hours)
    }
}

#endif
