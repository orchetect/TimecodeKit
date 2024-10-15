//
//  Timecode String Internal Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKitCore
import XCTest

final class Timecode_String_Internal_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testStringDecode() throws {
        // non-drop frame
        
        XCTAssertThrowsError(try Timecode.decode(timecode: ""))
        XCTAssertThrowsError(try Timecode.decode(timecode: "01564523"))
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0:0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00:00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;0;0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all periods - not supporting this.
        
        XCTAssertThrowsError(try Timecode.decode(timecode: "0.0.0.0"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "0.00.00.00"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "00.00.00.00"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "1.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "3 01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "12.01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "12.01.56.45.23"))
        
        // subframes
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00:00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23.05"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        // subframes
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23.05"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
    }
    
    func testStringDecodeEdgeCases() throws {
        // test for really large values
        
        // valid Int values
        XCTAssertEqual(
            try Timecode.decode(
                timecode: "1234567891234564567 1234567891234564567:1234567891234564567:1234567891234564567:1234567891234564567.1234567891234564567"
            ),
            Timecode.Components(
                d: 1234567891234564567,
                h: 1234567891234564567,
                m: 1234567891234564567,
                s: 1234567891234564567,
                f: 1234567891234564567,
                sf: 1234567891234564567
            )
        )
        
        // overflowing Int values should throw an error (and not crash)
        do {
            _ = try Timecode.decode(
                timecode: "12345678912345645678 12345678912345645678:12345678912345645678:12345678912345645678:12345678912345645678.12345678912345645678"
            )
            XCTFail("Should have thrown an error.")
        } catch let e as Timecode.StringParseError {
            guard e == .malformed else { XCTFail(); return }
        } catch {
            XCTFail("Caught wrong error: \(error)")
        }
    }
}
