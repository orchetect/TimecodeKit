//
//  SwiftUI Text Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2021-07-10.
//

/// -------------------------------------------------
/// NOTE (July 10 2021):
/// There is a bug preventing SwiftUI unit testing using
/// the ViewInspector open-source testing library,
/// so these tests have been commented out until that
/// can be rectified:
/// https://github.com/nalexn/ViewInspector/issues/122
/// -------------------------------------------------

//#if !os(watchOS) && canImport(SwiftUI) && canImport(Combine)
//
//import XCTest
//@testable import TimecodeKit
//import SwiftUI
//import ViewInspector
//
//extension Text: Inspectable { }
//
//struct TestContentView: View {
//    var timecode: Timecode
//
//    var body: some View {
//        //timecode.stringValueValidatedText()
//        Text("testing")
//    }
//}
//
//class Timecode_UT_UI_SwiftUI_Text: XCTestCase {
//
//    override func setUp() { }
//    override func tearDown() { }
//
//    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//    func testConverted() throws {
//
//        let tc = Timecode(TCC(h: 1), at: ._24)!
//
//        let testView = TestContentView(timecode: tc)
//
//        let string = try testView.inspect().text().string()
//
//        print(string)
//    }
//
//}
//
//#endif
