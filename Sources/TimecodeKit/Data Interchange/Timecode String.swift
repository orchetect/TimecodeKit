//
//  Timecode String.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Foundation
#endif

extension Timecode {
	
	// MARK: stringValue
	
	/// Timecode string representation.
	///
	/// Valid formats for 24-hour:
	///
	///     "00:00:00:00" "00:00:00;00"
	///     "0:00:00:00" "0:00:00;00"
	///     "00000000"
	///
	/// Valid formats for 100-day: All of the above, as well as:
	///
	///     "0 00:00:00:00" "0 00:00:00;00"
	///     "0:00:00:00:00" "0:00:00:00;00"
	///
	/// When setting, an improperly formatted timecode string or one with invalid values will cause the setter to fail silently.
	///
	/// (Validation is based on the frame rate and `upperLimit` property.)
	@inlinable public var stringValue: String {
		
		get {
			
			let sepDays = " "
			let sepMain = ":"
			let sepFrames = frameRate.isDrop ? ";" : ":"
			let sepSubFrames = "."
			
			var output = ""
			
			output += "\(days != 0 ? "\(days)\(sepDays)" : "")"
			output += "\(String(format: "%02d", hours  ))\(sepMain)"
			output += "\(String(format: "%02d", minutes))\(sepMain)"
			output += "\(String(format: "%02d", seconds))\(sepFrames)"
			output += "\(String(format: "%0\(frameRate.numberOfDigits)d", frames))"
			
			if displaySubFrames {
				let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
				
				output += "\(sepSubFrames)\(String(format: "%0\(numberOfSubFramesDigits)d", subFrames))"
			}
			
			return output
			
		}
		
		set {
			
			_ = setTimecode(exactly: newValue)
			
		}
		
	}
	
	/// Forms `.stringValue` using filename-compatible characters.
	public var stringValueFileNameCompatible: String {
		
		let result = stringValue
			.replacingOccurrences(of: ":", with: "-")
			.replacingOccurrences(of: ";", with: "-")
			.replacingOccurrences(of: " ", with: "-")
		
		return result
		
	}
	
	// MARK: stringValueValidated
	
	/// Returns `stringValue` as `NSAttributedString`, highlighting invalid values.
	///
	/// `invalidAttributes` are the `NSAttributedString` attributes applied to invalid values.
	/// If `invalidAttributes` are not passed, the default of red forground color is used.
	public func stringValueValidated(invalidAttributes: [NSAttributedString.Key : Any]? = nil,
									 withDefaultAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString
	{
		
		let sepDays = NSAttributedString(string: " ", attributes: attrs)
		let sepMain = NSAttributedString(string: ":", attributes: attrs)
		let sepFrames = NSAttributedString(string: frameRate.isDrop ? ";" : ":", attributes: attrs)
		let sepSubFrames = NSAttributedString(string: ".", attributes: attrs)
		
		#if os(macOS)
		let invalidColor = invalidAttributes
			?? [.foregroundColor : NSColor.red]
		#elseif os(iOS) || os(tvOS) || os(watchOS)
		let invalidColor = invalidAttributes
			?? [.foregroundColor : UIColor.red]
		#else
		let invalidColor = invalidAttributes
			?? []
		#endif
		
		let invalids = invalidComponents
		
		let output = NSMutableAttributedString(string: "", attributes: attrs)
		
		var piece: NSMutableAttributedString
		
		// days
		if days != 0 {
			piece = NSMutableAttributedString(string: "\(days)", attributes: attrs)
			if invalids.contains(.days) {
				piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
			}
			
			output.append(piece)
			
			output.append(sepDays)
			
		}
		
		// hours
		
		piece = NSMutableAttributedString(string: String(format: "%02d", hours),
										  attributes: attrs)
		if invalids.contains(.hours) {
			piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
		}
		
		output.append(piece)
		
		output.append(sepMain)
		
		// minutes
		
		piece = NSMutableAttributedString(string: String(format: "%02d", minutes),
										  attributes: attrs)
		if invalids.contains(.minutes) {
			piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
		}
		
		output.append(piece)
		
		output.append(sepMain)
		
		// seconds
		
		piece = NSMutableAttributedString(string: String(format: "%02d", seconds),
										  attributes: attrs)
		if invalids.contains(.seconds) {
			piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
		}
		
		output.append(piece)
		
		output.append(sepFrames)
		
		// frames
		
		piece = NSMutableAttributedString(string:
			String(format: "%0\(frameRate.numberOfDigits)d", frames),
										  attributes: attrs)
		if invalids.contains(.frames) {
			piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
		}
		
		output.append(piece)
		
		// subframes
		
		if displaySubFrames {
			let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
			
			output.append(sepSubFrames)
			
			piece = NSMutableAttributedString(string:
				String(format: "%0\(numberOfSubFramesDigits)d", subFrames),
											  attributes: attrs)
			if invalids.contains(.subFrames) {
				piece.addAttributes(invalidColor, range: NSRange(location: 0, length: piece.string.count))
			}
			
			output.append(piece)
		}
		
		return output
		
	}
	
}


// MARK: Setters

extension Timecode {
	
	/** Returns true/false depending on whether the string is formatted correctly or not.
	Values which are out-of-bounds will be clamped to minimum or maximum possible values. (Clamping is based on the frame rate and `upperLimit` property.)
	*/
	@discardableResult
	public mutating func setTimecode(clamping string: String) -> Bool {
		
		guard let tcVals = Timecode.decode(timecode: string) else { return false }
		
		setTimecode(clamping: tcVals)
		
		return true
		
	}
	
	/** Returns true/false depending on whether the string is formatted correctly or not.
	Values which are out-of-bounds will also cause the setter to fail, and return false. (Validation is based on the frame rate and `upperLimit` property.)
	*/
	@discardableResult
	public mutating func setTimecode(exactly string: String) -> Bool {
		
		guard let decoded = Timecode.decode(timecode: string) else { return false }
		
		return setTimecode(exactly: decoded)
		
	}
	
	/** Returns true/false depending on whether the string is formatted correctly or not.
	Values which are out-of-bounds will be clamped to minimum or maximum possible values. (Clamping is based on the frame rate and `upperLimit` property.)
	*/
	@discardableResult
	public mutating func setTimecode(wrapping string: String) -> Bool {
		
		guard let tcVals = Timecode.decode(timecode: string) else { return false }
		
		setTimecode(wrapping: tcVals)
		
		return true
		
	}
	
	/** Returns true/false depending on whether the string is formatted correctly or not.
	Timecode values will not be validated or rejected if they overflow.
	*/
	@discardableResult
	public mutating func setTimecode(rawValues string: String) -> Bool {
		
		guard let tcVals = Timecode.decode(timecode: string) else { return false }
		
		setTimecode(rawValues: tcVals)
		
		return true
		
	}
	
}

extension Timecode {
	
	/** Decodes a Timecode string into its component values, without validating.
	
	Returns nil only if the string is not formatted as expected; raw values themselves will be passed as-is.
	
	Valid formats for 24-hour:
	
	```
	"00:00:00:00" "00:00:00;00"
	"00:00:00:00.00" "00:00:00;00.00"
	```
	
	Valid formats for 100-day: All of the above, as well as:
	
	```
	"0 00:00:00:00" "0 00:00:00;00"
	"0:00:00:00:00" "0:00:00:00;00"
	"0 00:00:00:00.00" "0 00:00:00;00.00"
	"0:00:00:00:00.00" "0:00:00:00;00.00"
	```
	*/
	public static func decode(timecode string: String) -> Components? {
		
		let pattern = #"^(\d+)??[\:\s]??(\d+)[\:](\d+)[\:](\d+)[\:\;](\d+)[\.]??(\d+)??$"#

		let matches = string.regexMatches(captureGroupsFromPattern: pattern)

		// attempt to convert strings to integers, preserving indexes and preserving nils
		// essentially converting [String?] to [Int?]
		
		let ints = matches.map { $0 == nil ? nil : Int($0!) }
		
		// basic check - ensure there's at least 4 values but no more than 6
		
		let nonNilCount = ints.reduce(0, { $1 != nil ? $0 + 1 : $0 })
		
		guard (4...6).contains(nonNilCount) else { return nil }
		
		// return components
		
		return Components(d:  ints[0] ?? 0,
						  h:  ints[1] ?? 0,
						  m:  ints[2] ?? 0,
						  s:  ints[3] ?? 0,
						  f:  ints[4] ?? 0,
						  sf: ints[5] ?? 0)
		
	}
	
}
