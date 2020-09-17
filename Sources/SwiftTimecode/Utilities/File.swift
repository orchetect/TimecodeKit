//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

/// CUSTOM SHARED:
/// Outputs percentage values at defined intervals, from a input stream of values.
///
/// `maxValue` must be greater than `minValue`. `progress(value: T)` will not produce output if `value` is less than `minValue`, however `value` > `maxValue` will continue producing outputs > 100%.
///
/// Useful in debugging to the console to show incremental progress during operations that can take a fair amount of time to complete.
public struct SegmentedProgress<T: BinaryInteger> {
	
	/// Minimum value.
	public let minValue: T
	/// Internal cached value
	private let dblMinValue: Double
	
	/// Maximum value.
	public let maxValue: T
	/// Internal cached value
	private let dblMaxValue: Double
	
	/// How many segments to divide the entire range into.
	public var segments: Int = 100 {
		didSet { calculateSegmentInterval() }
	}
	
	/// Number of decimal places to round the percentage to.
	public var roundedToPlaces: Int = 0
	
	/// Internal, calculated. Do not access directly.
	private var segmentInterval: Double = 1.0
	
	/// Internal. Do not access directly.
	private mutating func calculateSegmentInterval() {
		if segments < 1 { segments = 1 } // validation
		segmentInterval = (Double(maxValue) - Double(minValue)) / Double(segments)
	}
	
	/// Internal
	private(set) var lastSegmentValue: Double
	/// Internal
	private var firstSegmentIssued = false
	/// Internal
	private var lastSegmentIssued = false
	
	public mutating func progress(value: T) -> String? {
		if (value == minValue) && !firstSegmentIssued {
			firstSegmentIssued = true
			return roundedPercentageString(0.0, toPlaces: roundedToPlaces)
		}
		
		if (value == maxValue) && !lastSegmentIssued {
			lastSegmentIssued = true
			return roundedPercentageString(100.0, toPlaces: roundedToPlaces)
		}
		
		let dblValue = Double(value)
		
		if dblValue >= lastSegmentValue + segmentInterval {
			let percentage = ((dblValue - dblMinValue) / (dblMaxValue - dblMinValue)) * 100.0
			
			lastSegmentValue = dblValue
			return roundedPercentageString(percentage, toPlaces: roundedToPlaces)
		}
		
		return nil
	}
	
	public init(_ range: ClosedRange<T>, segments: Int = 100, roundedToPlaces: Int = 0) {
		self.minValue = range.lowerBound
		self.dblMinValue = Double(self.minValue)
		
		self.maxValue = range.upperBound
		self.dblMaxValue = Double(self.maxValue)
		
		self.segments = segments
		self.lastSegmentValue = dblMinValue
		calculateSegmentInterval() // must call this here since segmets didSet won't trigger from init
		
		self.roundedToPlaces = roundedToPlaces
	}
	
	/// Internal: Utility function.
	private func roundedPercentageString(_ number: Double, toPlaces: Int) -> String {
		return String(format: "%.\(toPlaces)f", number) + "%"
	}
	
}
