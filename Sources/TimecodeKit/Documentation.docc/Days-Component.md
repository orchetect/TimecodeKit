# Days Component

Using the Days timecode component.

Although not covered by SMPTE spec, some DAWs (digital audio workstation) such as Cubase support the use of the Days timecode component for timelines longer than (or outside of) 24 hours.

By default, ``Timecode`` is constructed with an ``Timecode/upperLimit`` of 24-hour maximum expression (`._24Hours`) which suppresses the ability to use Days. To enable Days, set the limit to `._100Days`.

The limit setting naturally affects internal timecode validation routines, as well as clamping and wrapping.

```swift
// valid timecode range at 24 fps, with 24 hours limit
"00:00:00:00" ... "23:59:59:23"

// valid timecode range at 24 fps, with 100 days limit
"00:00:00:00" ... "99 23:59:59:23"
```
