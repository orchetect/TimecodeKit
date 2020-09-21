//
//  Timecode Samples.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-06-15.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode {
	
	/// (Lossy)
	/// Returns the current timecode converted to a duration in real-time audio samples at the given sample rate, rounded to the nearest sample.
	/// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
	public func samplesValue(atSampleRate: Int) -> Double {
		
		// prepare coefficients
		
		var fRate = frameRate.frameRateForElapsedFramesCalculation
		
		if frameRate.isDrop
		&& frameRate != ._30_drop
		&& frameRate != ._60_drop
		&& frameRate != ._120_drop {
			// all dropframe rates require this except 30 DF and its multiples
			fRate = Double(frameRate.maxFrames) / 1.001
		}
		
		var offset = 1.0
		switch frameRate {
		case ._23_976,
			 ._24_98,
			 ._29_97,
			 ._47_952,
			 ._59_94,
			 ._119_88:
			offset = 1.001	// not sure why this works, but it makes for an accurate calculation
			
		case ._24,
			 ._25,
			 ._29_97_drop,
			 ._30,
			 ._48,
			 ._50,
			 ._59_94_drop,
			 ._60,
			 ._100,
			 ._119_88_drop,
			 ._120:
			break
			
		case ._30_drop,
			 ._60_drop,
			 ._120_drop:
			offset = 0.999
			
		}
		
		// perform calculation
		
		var dbl = totalElapsedFrames * (Double(atSampleRate) / fRate * offset)
		
		// over-estimate so samples are just past the equivalent timecode
		// so calculations of samples back into timecode work reliably
		// otherwise, this math produces a samples value that can be a hair under the actual elapsed samples that would trigger the equivalent timecode
		
		dbl += 0.0001
		
		return dbl
		
	}
	
	/// (Lossy)
	/// Sets the timecode to the nearest frame at the current frame rate from elapsed audio samples.
	/// Returns false if it underflows or overflows valid timecode range.
	/// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
	@discardableResult
	public mutating func setTimecode(fromSamplesValue: Double,
									 atSampleRate: Int) -> Bool {
		
		// prepare coefficients
		
		var fRate = frameRate.frameRateForElapsedFramesCalculation
		
		if frameRate.isDrop
			&& frameRate != ._30_drop
			&& frameRate != ._60_drop
			&& frameRate != ._120_drop {
			// all dropframe rates require this except 30 DF and its multiples
			fRate = Double(frameRate.maxFrames) / 1.001
		}
		
		var offset = 1.0
		switch frameRate {
		case ._23_976,
			 ._24_98,
			 ._29_97,
			 ._47_952,
			 ._59_94,
			 ._119_88:
			offset = 1.001
			
		case ._24,
			 ._25,
			 ._29_97_drop,
			 ._30,
			 ._48,
			 ._50,
			 ._59_94_drop,
			 ._60,
			 ._100,
			 ._119_88_drop,
			 ._120:
			break
			
		case ._30_drop,
			 ._60_drop,
			 ._120_drop:
			offset = 0.999
			
		}
		
		// perform calculation
		
		let dbl = fromSamplesValue / (Double(atSampleRate) / fRate * offset)
		
		// then derive components
		let convertedComponents = Self.components(from: dbl,
												  at: frameRate,
												  subFramesDivisor: subFramesDivisor)
		
		return setTimecode(exactly: convertedComponents)
		
	}
	
}
