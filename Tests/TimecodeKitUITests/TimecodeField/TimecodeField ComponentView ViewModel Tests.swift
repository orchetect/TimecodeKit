//
//  TimecodeField ComponentView ViewModel Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import TimecodeKitUI
import XCTest

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class TimecodeField_ComponentView_ViewModel_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    private func viewModelFactory(
        component: Timecode.Component,
        rate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase? = nil,
        limit: Timecode.UpperLimit
    ) -> MockViewModel {
        let properties = Timecode.Properties(
            rate: rate ?? testFrameRate,
            base: base ?? testSubFramesBase,
            limit: limit
        )
        return MockViewModel(
            component: component,
            initialTimecodeProperties: properties
        )
    }
    
    // MARK: - Tests
    
    func testBaselineState() {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        XCTAssertEqual(model.component, .days)
        XCTAssertEqual(model.frameRate, testFrameRate)
        XCTAssertEqual(model.subFramesBase, testSubFramesBase)
        XCTAssertEqual(model.upperLimit, .max24Hours)
    }
    
    func testBaselineStateB() {
        let model = viewModelFactory(component: .hours, rate: .fps30, base: .max80SubFrames, limit: .max100Days)
        
        XCTAssertEqual(model.component, .hours)
        XCTAssertEqual(model.frameRate, .fps30)
        XCTAssertEqual(model.subFramesBase, .max80SubFrames)
        XCTAssertEqual(model.upperLimit, .max100Days)
    }
    
    func testInvisibleComponents_Max24Hours() {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: []), [.days, .subFrames])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.showSubFrames]), [.days])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.alwaysShowDays, .showSubFrames]), [])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.alwaysShowDays]), [.subFrames])
    }
    
    func testInvisibleComponents_Max100Hours() {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: []), [.subFrames])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.showSubFrames]), [])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.alwaysShowDays, .showSubFrames]), [])
        
        XCTAssertEqual(model.invisibleComponents(timecodeFormat: [.alwaysShowDays]), [.subFrames])
    }
    
    func testFirstVisibleComponent_Max24Hours() {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: []), .hours)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.showSubFrames]), .hours)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames]), .days)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays]), .days)
    }
    
    func testFirstVisibleComponent_Max100Hours() {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: []), .days)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.showSubFrames]), .days)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames]), .days)
        
        XCTAssertEqual(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays]), .days)
    }
    
    // MARK: - .previousComponent (24 Hours)
    
    func testDays_PreviousComponent_Max24Hours() {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .frames)
    }
    
    func testHours_PreviousComponent_Max24Hours() {
        let model = viewModelFactory(component: .hours, limit: .max24Hours)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    func testSubframes_PreviousComponent_Max24Hours() {
        let model = viewModelFactory(component: .subFrames, limit: .max24Hours)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .frames)
    }
    
    func testFrames_PreviousComponent_Max24Hours() {
        let model = viewModelFactory(component: .frames, limit: .max24Hours)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .seconds)
    }
    
    // MARK: - .previousComponent (100 Days)
    
    func testDays_PreviousComponent_Max100Days() {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .frames)
    }
    
    func testHours_PreviousComponent_Max100Days() {
        let model = viewModelFactory(component: .hours, limit: .max100Days)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .days)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    func testSubframes_PreviousComponent_Max100Days() {
        let model = viewModelFactory(component: .subFrames, limit: .max100Days)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .frames)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .frames)
    }
    
    func testFrames_PreviousComponent_Max100Days() {
        let model = viewModelFactory(component: .frames, limit: .max100Days)
        
        XCTAssertEqual(model.previousComponent(timecodeFormat: [], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .seconds)
        XCTAssertEqual(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .seconds)
    }
    
    // MARK: - .nextComponent (24 Hours)
    
    func testDays_NextComponent_Max24Hours() {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .hours)
    }
    
    func testHours_NextComponent_Max24Hours() {
        let model = viewModelFactory(component: .hours, limit: .max24Hours)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .minutes)
    }
    
    func testFrames_NextComponent_Max24Hours() {
        let model = viewModelFactory(component: .frames, limit: .max24Hours)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    func testSubframes_NextComponent_Max24Hours() {
        let model = viewModelFactory(component: .subFrames, limit: .max24Hours)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    // MARK: - .nextComponent (100 Days)
    
    func testDays_NextComponent_Max100Days() {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .hours)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .hours)
    }
    
    func testHours_NextComponent_Max100Days() {
        let model = viewModelFactory(component: .hours, limit: .max100Days)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .minutes)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .minutes)
    }
    
    func testFrames_NextComponent_Max100Days() {
        let model = viewModelFactory(component: .frames, limit: .max100Days)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .days)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .subFrames)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    func testSubframes_NextComponent_Max100Days() {
        let model = viewModelFactory(component: .subFrames, limit: .max100Days)
        
        XCTAssertEqual(model.nextComponent(timecodeFormat: [], wrap: .wrap), .days)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap), .days)
        XCTAssertEqual(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap), .days)
    }
    
    // MARK: - ViewModel.isDaysVisible()
    
    func testIsDaysVisible_Max24Hours() {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        XCTAssertFalse(VM.isDaysVisible(format: [], limit: .max24Hours))
        XCTAssertFalse(VM.isDaysVisible(format: [.showSubFrames], limit: .max24Hours))
        XCTAssertTrue(VM.isDaysVisible(format: [.alwaysShowDays, .showSubFrames], limit: .max24Hours))
        XCTAssertTrue(VM.isDaysVisible(format: [.alwaysShowDays], limit: .max24Hours))
    }
    
    func testIsDaysVisible_Max100Days() {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        XCTAssertTrue(VM.isDaysVisible(format: [], limit: .max100Days))
        XCTAssertTrue(VM.isDaysVisible(format: [.showSubFrames], limit: .max100Days))
        XCTAssertTrue(VM.isDaysVisible(format: [.alwaysShowDays, .showSubFrames], limit: .max100Days))
        XCTAssertTrue(VM.isDaysVisible(format: [.alwaysShowDays], limit: .max100Days))
    }
    
    // MARK: - ViewModel.isSubFramesVisible()
    
    func testIsSubFramesVisible() {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        XCTAssertFalse(VM.isSubFramesVisible(format: []))
        XCTAssertTrue(VM.isSubFramesVisible(format: [.showSubFrames]))
        XCTAssertTrue(VM.isSubFramesVisible(format: [.alwaysShowDays, .showSubFrames]))
        XCTAssertFalse(VM.isSubFramesVisible(format: [.alwaysShowDays]))
    }
}

// MARK: - Test Utilities

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
fileprivate class MockViewModel: TimecodeField.ComponentView.ViewModel {
    
}

#endif
