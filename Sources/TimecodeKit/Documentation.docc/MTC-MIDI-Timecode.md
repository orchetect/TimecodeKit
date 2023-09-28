# MTC (MIDI Timecode)

Information on MIDI Timecode (part of the MIDI Specification).

MIDI Timecode is a device synchronization protocol that encodes SPMTE timecode using MIDI 1.0 (or MIDI 2.0) as transport.

TimecodeKit does not implement MTC encoding or decoding directly.

Instead, [MIDIKit](https://github.com/orchetect/MIDIKit) (an open-source Swift MIDI I/O package for all Apple platforms) implements MTC encoding/decoding.
It imports TimecodeKit as a dependency and uses ``Timecode`` and ``TimecodeFrameRate`` as data structures.

## References

- [MIDI Timecode Specification on midi.org](https://www.midi.org/specifications/midi1-specifications/midi-time-code) (requires a free account to access)
- [MIDI Timecode](https://en.wikipedia.org/wiki/MIDI_timecode) on Wikipedia
