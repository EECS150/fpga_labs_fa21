import wave
import random
import struct
import sys
import math
import numpy as np

output_wav = wave.open('sq_wave.wav', 'w')
output_wav.setparams((2, 2, 44100, 0, 'NONE', 'not compressed'))

values = []

def sq_wave(duty_cycle):
    return int((50*duty_cycle)) * [1] + int((50*(1-duty_cycle))) * [0]

sines = [math.sin(x) for x in np.linspace(0, math.pi/2, 30)] * 50
data = []
for sine in sines:
    data += sq_wave(abs(sine)) * 1

for note in data:
    value = 0
    if (note == 0):
        value = -20000
    elif (note == 1):
        value = 20000
    else:
        continue
    packed_value = struct.pack('h', value)
    values.append(packed_value)
    values.append(packed_value)

value_str = ''.join(values)
output_wav.writeframes(value_str)
output_wav.close()
sys.exit(0)
