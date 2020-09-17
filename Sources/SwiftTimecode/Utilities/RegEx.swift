//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

extension String {
	
	/// CUSTOM SHARED:
	/// Returns an array of RegEx matches
	internal func regexMatches(pattern: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: pattern)
			let nsString = self as NSString
			let results = regex.matches(in: self, range: NSMakeRange(0, nsString.length))
			return results.map { nsString.substring(with: $0.range)}
		} catch { // catch let error as NSError {
			//llog("regexMatches(...) Error: Invalid RegEx: \(error.localizedDescription)")
			return []
		}
	}
	
	/// CUSTOM SHARED:
	/// Returns a string from a tokenized string of RegEx matches
	internal func regexMatches(pattern: String, replacementTemplate: String) -> String? {
		do {
			let regex = try NSRegularExpression(pattern: pattern)
			let nsString = self as NSString
			regex.numberOfMatches(in: self,
								  options: .withTransparentBounds,
								  range: NSMakeRange(0, nsString.length))
			let replaced = regex.stringByReplacingMatches(in: self,
														  options: .withTransparentBounds,
														  range: NSMakeRange(0, nsString.length),
														  withTemplate: replacementTemplate)
			
			return replaced
		} catch { // catch let error as NSError {
			return nil
		}
	}
	
	/// CUSTOM SHARED:
	/// Returns capture groups from regex matches. nil if an optional capture group is not matched.
	internal func regexMatches(captureGroupsFromPattern: String) -> [String?] {
		do {
			let regex = try NSRegularExpression(pattern: captureGroupsFromPattern, options: [])
			let nsString = self as NSString
			let results = regex.matches(in: self,
										options: .withTransparentBounds,
										range: NSMakeRange(0, nsString.length))
			var matches: [String?] = []
			
			for result in results {
				for i in 1..<result.numberOfRanges {
					let range = result.range(at: i)
					
					if range.location == NSNotFound {
						matches.append(nil)
					} else {
						matches.append(nsString.substring( with: range ))
					}
				}
			}
			
			return matches
		} catch { // catch let error as NSError {
			return []
		}
	}
	
}
