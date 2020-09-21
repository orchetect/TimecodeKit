//
//  FrameRate.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2018-07-20.
//  Copyright © 2018 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode {
	
	// MARK: - FrameRate
	
	public enum FrameRate: Int {
		
		/// 23.976 fps (aka 23.98)
		///
		/// Also known as 24p for HD video, sometimes rounded up to 23.98 fps. started out as the format for dealing with 24fps film in a NTSC post environment.
		case _23_976
		
		/// 24 fps
		///
		/// (film, ATSC, 2k, 4k, 6k)
		case _24
		
		/// 24.98 fps
		///
		/// This frame rate is commonly used to facilitate transfers between PAL and NTSC video and film sources. It is mostly used to compensate for some error.
		case _24_98
		
		/// 25 fps
		///
		/// (PAL, used in Europe, Uruguay, Argentina, Australia), SECAM, DVB, ATSC)
		case _25
		
		/// 29.97 fps (30p)
		///
		/// (NTSC American System (US, Canada, Mexico, Colombia, etc.), ATSC, PAL-M (Brazil))
		/// (30 / 1.001) frame/sec
		case _29_97
		
		/// 29.97 drop fps
		case _29_97_drop
		
		/// 30 fps
		///
		/// (ATSC) This is the frame count of NTSC broadcast video. However, the actual frame rate or speed of the video format runs at 29.97 fps.
		///
		/// This timecode clock does not run in realtime. It is slightly slower by 0.1%.
		/// ie: 1:00:00:00:00 at 30 fps is approx 1:00:00:00;02 in 29.97df
		case _30
		
		/// 30 drop fps:
		///
		/// The 30 fps drop-frame count is an adaptation that allows a timecode display running at 29.97 fps to actually show the clock-on-the-wall-time of the timeline by “dropping” or skipping specific frame numbers in order to “catch the clock up” to realtime.
		case _30_drop
		
		/// 47.952 (48p?)
		///
		/// Double 23.976 fps
		case _47_952
		
		/// 48 fps
		///
		/// Double 24 fps
		case _48
		
		/// 50 fps
		///
		/// Double 25 fps
		case _50
		
		/// 59.94 fps
		///
		/// Double 29.97 fps
		/// 
		/// This video frame rate is supported by high definition cameras and is compatible with NTSC (29.97 fps).
		case _59_94
		
		/// 59.94 drop fps
		///
		/// Double 29.97 drop fps
		case _59_94_drop
		
		/// 60 fps
		///
		/// Double 30 fps
		///
		/// This video frame rate is supported by many high definition cameras. However, the NTSC compatible 59.94 fps frame rate is much more common.
		case _60
		
		/// 60 drop fps
		///
		/// Double 30 fps
		case _60_drop
		
		/// 100 fps
		///
		/// Double 50 fps / quadruple 25 fps
		case _100
		
		/// 119.88 fps
		///
		/// Double 59.94 fps / quadruple 29.97 fps
		case _119_88
		
		/// 119.88 drop fps
		///
		/// Double 59.94 drop fps / quadruple 29.97 drop fps
		case _119_88_drop
		
		/// 120 fps
		///
		/// Double 60 fps / quadruple 30 fps
		case _120
		
		/// 120 drop fps
		///
		/// Double 60 fps drop / quadruple 30 fps drop
		case _120_drop
		
	}
	
}

extension Timecode.FrameRate: CaseIterable {
	
	/// All dropframe frame rates.
	public static let allDrop: [Self] = allCases.filter { $0.isDrop }
	
	/// All non-dropframe frame rates.
	public static let allNonDrop: [Self] = allCases.filter { !$0.isDrop }
	
}
