from mido import MidiFile
import mido
from parse import *
import json
import numpy as np

file = MidiFile("source.mid", clip = True)
# Here a midi example
# <meta message channel_prefix channel=0 time=0>
# <meta message track_name name='Marimba' time=0>
# <meta message instrument_name name='Marimba' time=0>
# <meta message time_signature numerator=4 denominator=4 clocks_per_click=24 notated_32nd_notes_per_beat=8 time=0>
# <meta message key_signature key='C' time=0>
# <meta message smpte_offset frame_rate=24 hours=33 minutes=0 seconds=0 frames=0 sub_frames=0 time=0>
# <meta message set_tempo tempo=600000 time=0>
# note_on channel=0 note=84 velocity=80 time=0
# note_off channel=0 note=84 velocity=64 time=120
# note_on channel=0 note=84 velocity=80 time=360
# note_off channel=0 note=84 velocity=64 time=120
# note_on channel=0 note=84 velocity=80 time=360
# note_off channel=0 note=84 velocity=64 time=120
# note_on channel=0 note=84 velocity=80 time=360
# note_off channel=0 note=84 velocity=64 time=120
# note_on channel=0 note=96 velocity=80 time=360
# note_off channel=0 note=96 velocity=64 time=120
# <meta message end_of_track time=1800>
index = 0
get = False
tempo = None
note = []
note_off = []
time = 0

index = 0

print(type(file.tracks[0]))
for message in file.tracks[0]:
    print(message)
    index += 1


print("*********")
p = parse("<meta message set_tempo tempo={tempo} time=0>", str(file.tracks[0][6]))
tempo = p["tempo"]
print("Tempo=",tempo)
print("len=", len(file.tracks[0][7:-1]))
for index in range(7,len(file.tracks[0][7:-1])+7, 2):
    print("Current TIME=", time)
    print(file.tracks[0][index])
    print(file.tracks[0][index+1])

    p_on = parse("note_{status} channel=0 note={note} velocity={velocity} time={time}", str(file.tracks[0][index]))
    note_on = int(p_on["note"])

    print(type(file.tracks[0][index]))
    # print("->", file.tracks[0][index].time)
    real_time = mido.tick2second(file.tracks[0][index].time, 480, int(tempo))
    real_time_off = mido.tick2second(file.tracks[0][index + 1].time, 480, int(tempo))
    print("->", file.tracks[0][index].time,
                np.around(real_time, decimals=2),
                np.around(real_time_off, decimals=2))

    time = time + real_time
    note.append({"note":int(note_on), "time":np.around(time, decimals=2)})
    time = time + real_time_off








print("Extraction midi is OK")

obj = {}
obj["tempo"] = int(tempo)
obj["notes"] = note

print(obj)

with open("source.json", 'w') as file:
    file.write(json.dumps(obj, indent=4, separators=(',', '=')))
