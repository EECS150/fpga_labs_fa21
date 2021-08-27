"""
This script converts a raw square wave signal from a Verilog simulation into a .wav audio file for playback.

Usage: python3 scripts/audio_from_sim.py sim/build/output.txt

This script will generate a file named output.wav that can be played using the 'play binary'
Playback: play output.wav
"""

import wave
import random
import struct
import sys

filepath = sys.argv[1]
values = []
with open(filepath, 'r') as samples_file:
    values = [int(line.rstrip('\n').strip()) for line in samples_file]
    max_value = max(values)
    scaled_values = [((val*40000) / max_value) + -20000 for val in values]
    packed_values = [struct.pack('<h', int(val)) for val in scaled_values]
    output_wav = wave.open('output.wav', 'w')
    # nchannels (1 - mono), sampwidth (2 bytes per sample), framerate (50 kHz), nframes (0)
    output_wav.setparams((1, 2, 50000, 0, 'NONE', 'not compressed'))
    output_wav.writeframes(b''.join(packed_values))
    output_wav.close()
sys.exit(0)
