//
//  TimecodeFrameRate.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - FrameRate

/// Industry-standard BITC (burn-in timecode) display rates.
/// Certain rates may be drop-frame or non-drop-frame.
///
/// Timecode is way of encoding a frame number, therefore _timecode frame rate_ may be independent of _video frame rate_.
///
/// Part of common confusion with timecode can arise from the use of “frames per second” in both the timecode and the actual video frame
/// rate. When used to describe timecode, frames per second represents how many frames of timecode are counted before one second of timecode
/// increments. When describing video frame rates, frames per second represents how many literal video frames are played back during the
/// span of one second of real wall-clock time.
///
/// For example, 24p video typically uses 24 fps timecode rate.
/// However, 29.97p video may use 29.97 fps or 29.97-drop fps timecode rate depending on post-production facility requirements, and
/// timecode at these rates do not match wall-clock time exactly.
///
/// Some video rates may correspond (or generally be compatible with) certain timecode rates and vice-versa.
/// To return a timecode rate's corresponding video rate, see ``videoFrameRate(interlaced:)``.
///
/// ## Topics
///
/// ### Rates
///
/// - ``fps23_976``
/// - ``fps24``
/// - ``fps24_98``
/// - ``fps25``
/// - ``fps29_97``
/// - ``fps29_97d``
/// - ``fps30``
/// - ``fps30d``
/// - ``fps47_952``
/// - ``fps48``
/// - ``fps50``
/// - ``fps59_94``
/// - ``fps59_94d``
/// - ``fps60``
/// - ``fps60d``
/// - ``fps90``
/// - ``fps95_904``
/// - ``fps96``
/// - ``fps100``
/// - ``fps119_88``
/// - ``fps119_88d``
/// - ``fps120``
/// - ``fps120d``
///
public enum TimecodeFrameRate: String, FrameRateProtocol {
    /// 23.976 fps (24/1.001)
    ///
    /// Also known as 24p for HD video, sometimes rounded up to 23.98 fps. Started out as the format for dealing with 24fps film in a NTSC
    /// post environment.
    ///
    /// This frame rate is used for film that is being transferred to NTSC video and must be slowed down for a 2-3 pull-down telecine
    /// transfer.
    case fps23_976 = "23.976"
    
    /// 24 fps
    ///
    /// The true speed of standard film cameras. (Film, ATSC, 2k, 4k, 6k)
    case fps24 = "24"
    
    /// 24.98 fps (25/1.001)
    ///
    /// This frame rate is commonly used to facilitate transfers between PAL and NTSC video and film sources. It is mostly used to
    /// compensate for some error.
    case fps24_98 = "24.98"
    
    /// 25 fps
    ///
    /// PAL video used in Europe, Uruguay, Argentina, Australia. (SECAM, DVB, ATSC)
    case fps25 = "25"
    
    /// 29.97 fps (30/1.001)
    ///
    /// NTSC video used in the US, Canada, Mexico, Colombia, etc. (ATSC, PAL-M Brazil)
    case fps29_97 = "29.97"
    
    /// 29.97 fps drop
    ///
    /// NTSC video used in the US, Canada, Mexico, Colombia, etc. (ATSC, PAL-M Brazil)
    case fps29_97d = "29.97d"
    
    /// 30 fps
    ///
    /// This frame rate is not a true video standard anymore but is sometimes used in music recording. Decades ago, it was the black and
    /// white NTSC broadcast standard. It is equal to NTSC video being pulled up to film speed after a 2-3 telecine transfer.
    ///
    /// This timecode clock does not run in realtime. It is slightly slower by 0.1%.
    /// ie: 1:00:00:00:00 (1 day/24 hours) at 30 fps is approx 1:00:00;02 in 29.97df
    case fps30 = "30"
    
    /// 30 fps drop
    ///
    /// This is an adaptation that allows a timecode display running at 29.97 fps to actually show the wall-clock time of the timeline by
    /// “dropping” or skipping specific frame numbers in order to “catch the clock up” to realtime.
    case fps30d = "30d"
    
    /// 47.952 (48/1.001)
    ///
    /// Double 23.976 fps
    case fps47_952 = "47.952"
    
    /// 48 fps
    ///
    /// Double 24 fps.
    case fps48 = "48"
    
    /// 50 fps
    ///
    /// Double 25 fps
    case fps50 = "50"
    
    /// 59.94 fps (60/1.001)
    ///
    /// Double 29.97 fps.
    ///
    /// This video frame rate is supported by high definition cameras and is compatible with NTSC (29.97 fps).
    case fps59_94 = "59.94"
    
    /// 59.94 fps drop
    ///
    /// Double 29.97 fps drop
    case fps59_94d = "59.94d"
    
    /// 60 fps
    ///
    /// Double 30 fps.
    ///
    /// This video frame rate is supported by many high definition cameras. However, the NTSC compatible 59.94 fps frame rate is much more
    /// common.
    case fps60 = "60"
    
    /// 60 fps drop
    ///
    /// Double 30 fps.
    ///
    /// See the description for 30 drop for more info.
    case fps60d = "60d"
    
    /// 90 fps
    ///
    /// Triple 30 fps.
    ///
    /// This video frame rate is supported by some high definition cameras and modern smartphones such as the iPhone 16
    /// Pro.
    case fps90 = "90"
    
    /// 95.904 fps (96/1.001)
    ///
    /// Double 47.952 fps / quadruple 23.976 fps
    case fps95_904 = "95.904"
    
    /// 96 fps
    ///
    /// Double 48 fps / quadruple 24 fps.
    case fps96 = "96"
    
    /// 100 fps
    ///
    /// Double 50 fps / quadruple 25 fps.
    case fps100 = "100"
    
    /// 119.88 fps (120/1.001)
    ///
    /// Double 59.94 fps / quadruple 29.97 fps.
    case fps119_88 = "119.88"
    
    /// 119.88 fps drop
    ///
    /// Double 59.94 fps drop / quadruple 29.97 fps drop.
    case fps119_88d = "119.88d"
    
    /// 120 fps
    ///
    /// Double 60 fps / quadruple 30 fps.
    case fps120 = "120"
    
    /// 120 fps drop
    ///
    /// Double 60 fps drop / quadruple 30 fps drop.
    ///
    /// See the description for 30 drop for more info.
    case fps120d = "120d"
}

extension TimecodeFrameRate: CaseIterable {
    /// All drop frame rates.
    public static let allDrop: [Self] = allCases.filter { $0.isDrop }
    
    /// All non-drop frame rates.
    public static let allNonDrop: [Self] = allCases.filter { !$0.isDrop }
}

extension TimecodeFrameRate: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension TimecodeFrameRate: Sendable { }

extension TimecodeFrameRate: Codable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension TimecodeFrameRate: Identifiable {
    public var id: Self { self }
}
